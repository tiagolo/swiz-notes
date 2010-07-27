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

package swiznotes.events
{

import flash.events.Event;

import swiznotes.model.vo.Note;

/**
 * @author Michael Schmalle
 */
public class SwizNotesEvent extends Event
{
	//--------------------------------------------------------------------------
	//
	//  Public :: Constants
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Restores the application's NotePad instances.
	 * 
	 * @eventType restoreState
	 */
	public static const RESTORE_STATE:String = "restoreState";
	
	/**
	 * Dispatched when the application has completly restored it's previous
	 * state.
	 * 
	 * @eventType restoreStateComplete
	 */
	public static const RESTORE_STATE_COMPLETE:String = "restoreStateComplete";
	
	/**
	 * Saves the application's NotePad instances.
	 * 
	 * @eventType saveState
	 */
	public static const SAVE_STATE:String = "saveState";
	
	/**
	 * Dispatched when the application has completly saved it's current
	 * state.
	 * 
	 * @eventType saveStateComplete
	 */
	public static const SAVE_STATE_COMPLETE:String = "saveStateComplete";
	
	/**
	 * Saves the application's NotePad instances.
	 * 
	 * @eventType saveBackupState
	 */
	public static const SAVE_BACKUP_STATE:String = "saveBackupState";
	
	/**
	 * Dispatched when the application has completly saved it's current
	 * state.
	 * 
	 * @eventType saveBackupStateComplete
	 */
	public static const SAVE_BACKUP_STATE_COMPLETE:String = "saveBackupStateComplete";
	
	/**
	 * @eventType applicationClose
	 */
	public static const APPLICATION_CLOSE:String = "applicationClose";
	
	/**
	 * @eventType applicationExit
	 */
	public static const APPLICATION_EXIT:String = "applicationExit";
	
	/**
	 * @eventType applicationStateChange
	 */
	public static const APPLICATION_STATE_CHANGE:String = "applicationStateChange";
	
	/**
	 * @eventType SwizNotesEvent/displayStateChange
	 */
	public static const DISPLAY_STATE_CHANGE:String = "SwizNotesEvent/displayStateChange";
	
	//--------------------------------------------------------------------------
	//
	//  Public :: Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @see swiznotes.model.ApplicationState
	 */
	public var state:String;
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */	
	public function SwizNotesEvent(type:String, 
								   bubbles:Boolean = false, 
								   cancelable:Boolean = false)
	{
		super(type, bubbles, cancelable);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden Public :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */	
	public override function clone():Event
	{
		return new SwizNotesEvent(type, bubbles, cancelable);
	}
}
}