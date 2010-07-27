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

package swiznotes.model
{

import flash.events.IEventDispatcher;

import org.swizframework.utils.logging.SwizLogger;

import spark.components.WindowedApplication;

import swiznotes.events.NotePadEvent;
import swiznotes.events.SwizNotesEvent;
import swiznotes.model.vo.Note;

/**
 * The <strong>ApplicationModel</strong> holds the state of the 
 * <code>ApplicationController</code>.
 * 
 * @author Michael Schmalle
 * @source
 */
public class ApplicationModel
{
	//--------------------------------------------------------------------------
	//
	//  Public :: Variables
	//
	//--------------------------------------------------------------------------
	
	[Dispatcher]
	public var dispatcher:IEventDispatcher;
	
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
	//  Public :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  application
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _application:WindowedApplication;
	
	/**
	 * TODO Docme
	 */
	public function get application():WindowedApplication
	{
		return _application;
	}
	
	/**
	 * @private
	 */	
	public function set application(value:WindowedApplication):void
	{
		if (_application)
			return;
		
		_application = value;
	}
	
	//----------------------------------
	//  initialized
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _initialized:Boolean;
	
	/**
	 * TODO Docme
	 */
	public function get initialized():Boolean
	{
		return _initialized;
	}
	
	/**
	 * @private
	 */	
	public function set initialized(value:Boolean):void
	{
		if (_initialized == value)
		{
			logger.warn("Application already initialized");
			return;
		}
		
		_initialized = value;
		
		logger.info("Application initialized");
	}
	
	//----------------------------------
	//  displayState
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _displayState:String;
	
	[Bindable]
	/**
	 * The current displayState of the WindowedApplication.
	 * 
	 * <p>Possible values; normal, minimized.</p>
	 * 
	 * @event swiznotes.events.SwizNotesEvent#DISPLAY_STATE_CHANGE
	 */
	public function get displayState():String
	{
		return _displayState;
	}
	
	/**
	 * @private
	 */	
	public function set displayState(value:String):void
	{
		_displayState = value;
		
		logger.info("Application displayState changed to '{0}'", _displayState);
		
		dispatcher.dispatchEvent(new SwizNotesEvent(
			SwizNotesEvent.DISPLAY_STATE_CHANGE));
	}
	
	
	//----------------------------------
	//  state
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _state:String;
	
	/**
	 * TODO Docme
	 */
	public function get state():String
	{
		return _state;
	}
	
	/**
	 * @private
	 */	
	public function set state(value:String):void
	{
		if (_state == value)
			return;
		
		_state = value;
		
		logger.warn("Application state change '{0}'", _state);
		
		var e:SwizNotesEvent = new SwizNotesEvent(
			SwizNotesEvent.APPLICATION_STATE_CHANGE);
		e.state = _state;
		dispatcher.dispatchEvent(e);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function ApplicationModel()
	{
		super();
	}
}
}