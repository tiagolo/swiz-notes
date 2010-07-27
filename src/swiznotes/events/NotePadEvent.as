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
import flash.ui.ContextMenu;

import swiznotes.components.NotePad;
import swiznotes.model.vo.Note;

/**
 * @author Michael Schmalle
 */
public class NotePadEvent extends Event
{
	//--------------------------------------------------------------------------
	//
	//  Public :: Constants
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @eventType newClick
	 */
	public static const NEW_CLICK:String = "newClick";
	
	/**
	 * @eventType closeClick
	 */
	public static const CLOSE_CLICK:String = "closeClick";
	
	/**
	 * @eventType textChange
	 */
	public static const TEXT_CHANGE:String = "textChange";
	
	/**
	 * @eventType notePadFocus
	 */
	public static const NOTE_PAD_FOCUS:String = "notePadFocus";
	
	/**
	 * @eventType NotePadEvent/displayStateChange
	 */
	public static const DISPLAY_STATE_CHANGE:String = "NotePadEvent/displayStateChange";
	
	/**
	 * @eventType contextMenuContribute
	 */
	public static const CONTEXT_MENU_CONTRIBUTE:String = "contextMenuContribute";
	
	//--------------------------------------------------------------------------
	//
	//  Public :: Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * The Note.
	 */
	public var notePad:NotePad;
	
	/**
	 * The NotePad's ContextMenu.
	 */
	public var menu:ContextMenu;
	
	/**
	 * A String requested NotePad display state.
	 */
	public var displayState:String;
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function NotePadEvent(type:String, 
								 bubbles:Boolean = false, 
								 cancelable:Boolean = false,
								 notePad:NotePad = null)
	{
		super(type, bubbles, cancelable);
		
		this.notePad = notePad;
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
		var event:NotePadEvent = new NotePadEvent(type, bubbles, cancelable, notePad);
		event.menu = menu;
		return event;
	}
}
}