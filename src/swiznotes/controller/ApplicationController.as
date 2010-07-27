////////////////////////////////////////////////////////////////////////////////
// Copyright 2010 Michael Schmalle - Teoti Graphix, LLC
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
// http://www.apache.org/licenses/LICENSE-2.0 
// 
// Unless required by applicable law or agreed to in writing, software 
// distributed under the License is distributed on an "AS IS" BASIS, 
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and 
// limitations under the License
// 
// Author: Michael Schmalle, Principal Architect
// mschmalle at teotigraphix dot com
////////////////////////////////////////////////////////////////////////////////

package swiznotes.controller
{

import flash.display.NativeWindowDisplayState;
import flash.events.Event;
import flash.events.NativeWindowDisplayStateEvent;

import mx.events.AIREvent;
import mx.events.FlexEvent;

import org.swizframework.controller.AbstractController;
import org.swizframework.utils.logging.SwizLogger;

import spark.components.WindowedApplication;

import swiznotes.config.ApplicationConfig;
import swiznotes.core.mediate_handler;
import swiznotes.events.NoteEvent;
import swiznotes.events.SwizNotesEvent;
import swiznotes.model.ApplicationModel;
import swiznotes.model.ApplicationState;
import swiznotes.model.NoteModel;
import swiznotes.model.vo.Note;

/**
 * The <strong>ApplicationController</strong> manages the highest level of the
 * SwizNotes application.
 * 
 * <p>The controller uses the <code>ApplicationModel</code> to track various
 * states of the application.</p>
 * 
 * @author Michael Schmalle
 * @source
 */
public class ApplicationController extends AbstractController
{
	//--------------------------------------------------------------------------
	//
	//  Public :: Variables
	//
	//--------------------------------------------------------------------------
	
	[Inject]
	public var applicationConfig:ApplicationConfig;
	
	[Inject]
	public var applicationModel:ApplicationModel;
	
	[Inject]
	public var noteModel:NoteModel;
	
	//--------------------------------------------------------------------------
	//
	//  Protected :: Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	protected var logger:SwizLogger = SwizLogger.getLogger(this);
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function ApplicationController()
	{
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Public API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Brings all <code>NotePad</code> windows to the top of their stack.
	 * 
	 * <p>In the SwizNotes application, utility windows are used for the window
	 * type and a window activation of the application will not bring the
	 * utility windows to the front. With this method, the "activation" is
	 * done using the index positions in the dataProvider.</p>
	 */	
	public function bringAllToTop():void
	{
		for (var i:int = 0; i < noteModel.dataProvider.length; i++)
		{
			Note(noteModel.dataProvider[i]).window.orderToFront();
		}
		
		if (noteModel.currentItem)
		{
			dispatcher.dispatchEvent(new NoteEvent(
				NoteEvent.NOTE_CHANGE, noteModel.currentItem));	
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  mediate_handler :: Handlers
	//
	//--------------------------------------------------------------------------
	
	[Mediate(event="mx.events.FlexEvent.APPLICATION_COMPLETE")]
	/**
	 * @private
	 */
	mediate_handler function applicationCompleteHandler(event:FlexEvent):void
	{
		var application:WindowedApplication = event.target as WindowedApplication;
		
		// save ref to application
		applicationModel.application = application;
		// add application handlers
		application.addEventListener(
			AIREvent.WINDOW_ACTIVATE, application_windowActivateHandler);
		application.addEventListener(
			NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE, application_displayStateChangeHandler);
		
		applicationModel.state = ApplicationState.STARTING;
	}
	
	[Mediate(event="SwizNotesEvent.RESTORE_STATE_COMPLETE")]
	/**
	 * @private
	 */
	mediate_handler function restoreSateCompleteHandler(event:Event):void
	{
		applicationModel.state = ApplicationState.STARTED;
	}
	
	[Mediate(event="flash.events.Event.CLOSE")]
	/**
	 * @private
	 */
	mediate_handler function closeHandler(event:Event):void
	{
		// dispatches SwizNotesEvent.SAVE_STATE
		applicationModel.state = ApplicationState.STOPPING;
	}
	
	[Mediate(event="SwizNotesEvent.SAVE_STATE_COMPLETE")]
	/**
	 * @private
	 */
	mediate_handler function saveStateCompleteHandler(event:Event):void
	{
		// called when the NoteController has finished saving
		// It's nice to have this async since sometime down the road we
		// may want to save to a server where a synchronous method would not work
		dispatcher.dispatchEvent(new SwizNotesEvent(SwizNotesEvent.APPLICATION_CLOSE));
	}
	
	[Mediate(event="SwizNotesEvent.APPLICATION_EXIT")]
	/**
	 * @private
	 */
	mediate_handler function applicationExitHandler(event:Event):void
	{
		// closes the NativeApplication's window
		applicationModel.application.close();
	}
	
	[Mediate(event="SwizNotesEvent.APPLICATION_STATE_CHANGE",properties="state")]
	/**
	 * @private
	 */
	mediate_handler function applicationStateChangeHandler(state:String):void
	{
		switch (state)
		{
			case ApplicationState.STARTING:
				// start the restoring of notes
				// Will call NoteController.restoreState()
				dispatcher.dispatchEvent(new SwizNotesEvent(SwizNotesEvent.RESTORE_STATE));
				break;
			
			case ApplicationState.STARTED:
				// setting this flag here allows the rest of the application
				// to know that all windows have been restored and opened.
				// It's good to have "mileposts" in global app models
				applicationModel.initialized = true;
				break;
			
			case ApplicationState.STOPPING:
				// calls the NoteController.saveState() method
				dispatcher.dispatchEvent(new SwizNotesEvent(SwizNotesEvent.SAVE_STATE));
				break;
		}
	}
	
	[Mediate(event="NoteEvent.NOTE_CLOSE_COMPLETE")]
	/**
	 * @private
	 */
	mediate_handler function closeCompleteHandler(event:Event):void
	{
		var len:int = noteModel.dataProvider.length;
		if (applicationConfig.autoExit && len == 0)
			dispatcher.dispatchEvent(new SwizNotesEvent(SwizNotesEvent.APPLICATION_EXIT));
	}
	
	//--------------------------------------------------------------------------
	//
	//  Private :: Handlers
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private function application_windowActivateHandler(event:AIREvent):void
	{
		logger.info("ApplicationWindow activated");
		
		bringAllToTop();
	}
	
	/**
	 * @private
	 */
	private function application_displayStateChangeHandler(event:NativeWindowDisplayStateEvent):void
	{
		var state:String = event.afterDisplayState;
		applicationModel.displayState = state;
		
		if (state == NativeWindowDisplayState.NORMAL)
			bringAllToTop();
	}
}
}