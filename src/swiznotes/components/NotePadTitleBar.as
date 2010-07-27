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

package swiznotes.components
{

import flash.events.MouseEvent;

import mx.core.EventPriority;
import mx.core.IWindow;

import spark.components.Window;
import spark.components.supportClasses.ButtonBase;
import spark.components.windowClasses.TitleBar;

import swiznotes.events.NotePadEvent;
import swiznotes.util.NotePadUtil;

//--------------------------------------
//  SkinStates
//--------------------------------------

/**
 * The titlebar over state.
 */
[SkinState("over")]

//--------------------------------------
//  Events
//--------------------------------------

/**
 * @copy swiznotes.events.NotePadEvent#NEW_CLICK
 */
[Event(name="newClick",type="swiznotes.events.NotePadEvent")]

/**
 * @copy swiznotes.events.NotePadEvent#CLOSE_CLICK
 */
[Event(name="closeClick",type="swiznotes.events.NotePadEvent")]

/**
 * @copy swiznotes.events.NotePadEvent#NOTE_PAD_FOCUS
 */
[Event(name="notePadFocus",type="swiznotes.events.NotePadEvent")]

//--------------------------------------
//  Class
//--------------------------------------

/**
 * @author Michael Schmalle
 * @source
 */
public class NotePadTitleBar extends TitleBar
{
	//--------------------------------------------------------------------------
	//
	//  Public SkinPart :: Variables
	//
	//--------------------------------------------------------------------------
	
	[SkinPart(required="true")]
	/**
	 * The newButton display.
	 */
	public var newButton:ButtonBase;
	
	//--------------------------------------------------------------------------
	//
	//  Private :: Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private var mouseIsOver:Boolean = false;
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function NotePadTitleBar()
	{
		super();
		
		addEventListener(MouseEvent.MOUSE_DOWN, this_mouseDownHandler);
		addEventListener(MouseEvent.MOUSE_OVER, this_mouseOverHandler);
		addEventListener(MouseEvent.MOUSE_OUT, this_mouseOutHandler);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden Protected :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	override protected function partAdded(partName:String, instance:Object):void
	{
		super.partAdded(partName, instance);
		
		if (instance == newButton)
		{
			newButton.focusEnabled = false;
			newButton.addEventListener(
				MouseEvent.CLICK, newDisplay_clickHandler);
			newButton.addEventListener(
				MouseEvent.MOUSE_DOWN, button_mouseDownHandler);
		}
		
		if (instance == closeButton)
		{
			closeButton.addEventListener(
				MouseEvent.CLICK, closeButton_clickHandler, false, EventPriority.BINDING);
		}
	}
	
	/**
	 * @private
	 */
	override protected function partRemoved(partName:String, instance:Object):void
	{
		super.partRemoved(partName, instance);
		
		if (instance == newButton)
		{
			newButton.removeEventListener(
				MouseEvent.CLICK, newDisplay_clickHandler);
			newButton.removeEventListener(
				MouseEvent.MOUSE_DOWN, button_mouseDownHandler);
		}
		
		if (instance == closeButton)
		{
			closeButton.removeEventListener(
				MouseEvent.CLICK, closeButton_clickHandler);
		}
	}
	
	/**
	 * @private
	 */
	override protected function getCurrentSkinState():String
	{
		// HACK super dosn't check to see if the window is closed
		var window:IWindow = NotePadUtil.getWindow(this);
		
		if (!window || Window(window).closed)
			return "normal";
		
		var state:String = super.getCurrentSkinState();
		
		if (mouseIsOver)
			return "over";
		
		return state;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Private :: Handlers
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private function this_mouseDownHandler(event:MouseEvent):void
	{
		dispatchEvent(new NotePadEvent(NotePadEvent.NOTE_PAD_FOCUS));
	}
	
	/**
	 * @private
	 */
	private function this_mouseOverHandler(event:MouseEvent):void
	{
		mouseIsOver = true;
		invalidateSkinState();
	}
	
	/**
	 * @private
	 */
	private function this_mouseOutHandler(event:MouseEvent):void
	{
		mouseIsOver = false;
		invalidateSkinState();
	}
	
	/**
	 * @private
	 */
	private function button_mouseDownHandler(event:MouseEvent):void
	{
		event.stopPropagation();
	}	
	
	/**
	 * @private
	 */
	private function newDisplay_clickHandler(event:MouseEvent):void
	{
		dispatchEvent(new NotePadEvent(NotePadEvent.NEW_CLICK));
	}
	
	/**
	 * @private
	 */
	private function closeButton_clickHandler(event:MouseEvent):void
	{
		// stopping propagation here does not allow the TitleBar's close
		// handler to call window.close()
		event.stopImmediatePropagation();
		
		dispatchEvent(new NotePadEvent(NotePadEvent.CLOSE_CLICK));
	}
}
}