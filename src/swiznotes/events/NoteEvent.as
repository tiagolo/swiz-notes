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
public class NoteEvent extends Event
{
	//--------------------------------------------------------------------------
	//
	//  Public :: Constants
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @eventType saveNoteAs
	 */
	public static const SAVE_NOTE_AS_REQUESTED:String = "saveNoteAsRequested";
	
	/**
	 * @eventType saveNoteAsComplete
	 */
	public static const SAVE_NOTE_AS_COMPLETE:String = "saveNoteAsComplete";
	
	/**
	 * @eventType noteCreate
	 */
	public static const NOTE_CREATE:String = "noteCreate";
	
	/**
	 * @eventType noteOpen
	 */
	public static const NOTE_OPEN:String = "noteOpen";
	
	/**
	 * @eventType noteCloseRequested
	 */
	public static const NOTE_CLOSE_REQUESTED:String = "noteCloseRequested";
	
	/**
	 * @eventType noteCloseClickRequested
	 */
	public static const NOTE_CLOSE_CLICK_REQUESTED:String = "noteCloseClickRequested";
	
	/**
	 * @eventType noteCloseNotePad
	 */
	public static const NOTE_CLOSE_NOTE_PAD:String = "noteCloseNotePad";
	
	/**
	 * @eventType noteCloseComplete
	 */
	public static const NOTE_CLOSE_COMPLETE:String = "noteCloseComplete";
	
	/**
	 * @eventType noteChangeRequested
	 */
	public static const NOTE_CHANGE_REQUESTED:String = "noteChangeRequested";
	
	/**
	 * @eventType noteChange
	 */
	public static const NOTE_CHANGE:String = "noteChange";
	
	/**
	 * @eventType fontFamilyChange
	 */
	public static const FONT_FAMILY_CHANGE:String = "fontFamilyChange";
	
	/**
	 * @eventType fontSizeChange
	 */
	public static const FONT_SIZE_CHANGE:String = "fontSizeChange";
	
	//--------------------------------------------------------------------------
	//
	//  Public :: Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * The Note.
	 */
	public var note:Note;
	
	/**
	 * The trigger Event instance.
	 */
	public var trigger:Event;
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function NoteEvent(type:String, note:Note = null)
	{
		super(type)
		
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
	public override function clone():Event
	{
		return new NoteEvent(type, note);
	}
}
}