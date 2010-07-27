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
public class ConfirmationEvent extends Event
{
	//--------------------------------------------------------------------------
	//
	//  Public :: Constants
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @eventType ConfirmationEvent/confirm
	 */
	public static const CONFIRM:String = "ConfirmationEvent/confirm";
	
	//--------------------------------------------------------------------------
	//
	//  Public :: Variables
	//
	//--------------------------------------------------------------------------

	/**
	 * 
	 */
	public var note:Note;
	
	/**
	 * 
	 */
	public var confirmed:Boolean;
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function ConfirmationEvent(type:String, note:Note, confirmed:Boolean)
	{
		super(type)
		
		this.note = note;
		this.confirmed = confirmed;
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
		return new ConfirmationEvent(type, note, confirmed);
	}
}
}