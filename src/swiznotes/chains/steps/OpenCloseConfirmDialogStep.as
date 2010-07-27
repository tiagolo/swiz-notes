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

package swiznotes.chains.steps
{

import flash.display.Screen;
import flash.events.Event;
import flash.events.IEventDispatcher;

import org.swizframework.utils.chain.CommandChainStep;

import swiznotes.events.ConfirmationEvent;
import swiznotes.events.NoteEvent;
import swiznotes.model.vo.Note;
import swiznotes.views.ConfirmDialog;
import swiznotes.chains.CloseRequestChain;

/**
 * A command step that opens and manages a ConfirmationDialog.
 * 
 * @author Michael Schmalle
 * @source
 */
public class OpenCloseConfirmDialogStep extends CommandChainStep
{
	//--------------------------------------------------------------------------
	//
	//  Private :: Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private var dispatcher:IEventDispatcher;
	
	/**
	 * @private
	 */
	private var note:Note;
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function OpenCloseConfirmDialogStep(dispatcher:IEventDispatcher, note:Note)
	{
		super();
		
		this.dispatcher = dispatcher;
		this.note = note;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden Public :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	override public function execute():void
	{
		// create the dialog
		var dialog:ConfirmDialog = new ConfirmDialog();
		
		// pass the dialog ref to the parent chain
		var parent:CloseRequestChain = chain as CloseRequestChain;
		if (parent)
			parent.dialog = dialog;
		
		// save the note for later
		dialog.note = note;
		// add confirm and close listeners
		dialog.addEventListener(ConfirmationEvent.CONFIRM, dialog_confirmHandler);
		dialog.addEventListener(Event.CLOSE, dialog_closeHandler);
		// open the native window
		dialog.open();
		
		// calc center of dialog on the note's Screen (for multi-monitor setup)
		var screens:Array = Screen.getScreensForRectangle(note.window.nativeWindow.bounds);
		var screen:Screen = screens[0];
		
		dialog.nativeWindow.x = ((screen.visibleBounds.width - 
			dialog.nativeWindow.width) / 2) + screen.visibleBounds.left;
		dialog.nativeWindow.y = ((screen.visibleBounds.height - 
			dialog.nativeWindow.height) / 2) + screen.visibleBounds.top;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Private :: Handlers
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private function dialog_confirmHandler(event:ConfirmationEvent):void
	{
		if (event.confirmed)
		{
			// let the NoteController handle the real Note close now
			dispatcher.dispatchEvent(new NoteEvent(
				NoteEvent.NOTE_CLOSE_REQUESTED, event.note));
		}
		else
		{
			// refocus current NotePad
			// we are not sending a close request event since the user clicked No,
			// so we are just refocusing the currentItem in the dp
			dispatcher.dispatchEvent(new NoteEvent(
				NoteEvent.NOTE_CHANGE, event.note));
		}
		
		// close dialog if not closed and complete step
		dialog_closeHandler(event);
	}
	
	/**
	 * @private
	 */
	private function dialog_closeHandler(event:Event):void
	{
		var dialog:ConfirmDialog = event.currentTarget as ConfirmDialog;
		// if the dialog is not closed, close it (this happens when Yes or No is
		// clicked), the close event already has closed the dialog
		if (!dialog.closed)
			dialog.close();
		
		// move to the next step
		complete();
	}
}
}