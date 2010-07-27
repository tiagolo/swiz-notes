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

import flash.display.NativeWindowResize;
import flash.display.NativeWindowSystemChrome;
import flash.display.NativeWindowType;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.NativeWindowBoundsEvent;
import flash.ui.ContextMenu;

import mx.core.mx_internal;

import spark.components.TextArea;
import spark.components.Window;
import spark.events.TextOperationEvent;

import swiznotes.events.NotePadEvent;
import swiznotes.model.vo.Note;

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

/**
 * @copy swiznotes.events.NotePadEvent#CONTEXT_MENU_CONTRIBUTE
 */
[Event(name="contextMenuContribute",type="swiznotes.events.NotePadEvent")]

/**
 * @copy swiznotes.events.NotePadEvent#TEXT_CHANGE
 */
[Event(name="textChange",type="swiznotes.events.NotePadEvent")]

//--------------------------------------
//  Styles
//--------------------------------------

/**
 * The background gradient for the NotePad's background fill.
 */
[Style(name="backgroundGradient",type="mx.graphics.LinearGradient",inherit="no")]

//--------------------------------------
//  Class
//--------------------------------------

/**
 * The <strong>NotePad</strong> 
 * 
 * @author Michael Schmalle
 * @source
 */
public class NotePad extends Window
{	
	//--------------------------------------------------------------------------
	//
	//  Private :: Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private var edgeOrCorner:String;
	
	//--------------------------------------------------------------------------
	//
	//  Public SkinPart :: Variables
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  textAreaDisplay
	//----------------------------------
	
	[SkinPart(required="true")]
	
	/**
	 * Displays the textArea component.
	 */
	public var textAreaDisplay:TextArea;
	
	//--------------------------------------------------------------------------
	//
	//  Public :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  note
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _note:Note;
	
	/**
	 * @private
	 */
	protected var noteChanged:Boolean = false;
	
	[Bindable("noteChanged")]
	
	/**
	 * The current note the notepad displays.
	 */
	public function get note():Note
	{
		return _note;
	}
	
	/**
	 * @private
	 */	
	public function set note(value:Note):void
	{
		if (_note == value)
			return;
		
		if (_note)
			_note.window = null;
		
		_note = value;
		_note.window = this;
		
		noteChanged = true;
		invalidateProperties();
		
		dispatchEvent(new Event("noteChanged"));
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function NotePad()
	{
		super();
		
		showStatusBar = false;
		systemChrome = NativeWindowSystemChrome.NONE;
		transparent = true;
		type = NativeWindowType.UTILITY;
		
		addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden Public :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	override public function open(openWindowActive:Boolean=true):void
	{
		super.open(openWindowActive);
		
		nativeWindow.addEventListener(
			NativeWindowBoundsEvent.MOVE, updateBoundsHandler);
		nativeWindow.addEventListener(
			NativeWindowBoundsEvent.RESIZE, updateBoundsHandler);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden Protected :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	override protected function commitProperties():void
	{
		super.commitProperties();
		
		if (noteChanged)
		{
			commitNote();
			noteChanged = false;
		}
	}
	
	/**
	 * @private
	 */
	override protected function partAdded(partName:String, instance:Object):void
	{
		super.partAdded(partName, instance);
		
		if (instance == titleBar)
		{
			titleBar.addEventListener(NotePadEvent.NEW_CLICK, passThruHandler);
			titleBar.addEventListener(NotePadEvent.CLOSE_CLICK, passThruHandler);
			titleBar.addEventListener(NotePadEvent.NOTE_PAD_FOCUS, passThruHandler);
		}
		
		if (instance == textAreaDisplay)
		{
			textAreaDisplay.addEventListener(
				TextOperationEvent.CHANGE, textAreaDisplay_changeHandler);
			
			var menu:ContextMenu = new ContextMenu();
			
			var e:NotePadEvent = new NotePadEvent(
				NotePadEvent.CONTEXT_MENU_CONTRIBUTE, false, false, this);
			e.menu = menu;
			dispatchEvent(e);
			
			menu.clipboardMenu = true;
			textAreaDisplay.textDisplay.contextMenu = menu;
			
			commitNote();
			noteChanged = false;
		}
	}
	
	/**
	 * @private
	 */
	override protected function partRemoved(partName:String, instance:Object):void
	{
		if (instance == titleBar)
		{
			titleBar.removeEventListener(NotePadEvent.NEW_CLICK, passThruHandler);
			titleBar.removeEventListener(NotePadEvent.CLOSE_CLICK, passThruHandler);
			titleBar.removeEventListener(NotePadEvent.NOTE_PAD_FOCUS, passThruHandler);
		}
		
		if (instance == textAreaDisplay)
		{
			textAreaDisplay.removeEventListener(
				TextOperationEvent.CHANGE, textAreaDisplay_changeHandler);
		}
	}
	
	/**
	 * @private
	 */
	override protected function mouseDownHandler(event:MouseEvent):void
	{
		if (edgeOrCorner && edgeOrCorner != NativeWindowResize.NONE)
		{
			startResize(edgeOrCorner);
			event.stopPropagation();
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  Protected :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Commits a new Note instance into the component.
	 */
	protected function commitNote():void
	{
		if (!_note)
			return;
		
		nativeWindow.x = note.x;
		nativeWindow.y = note.y;
		nativeWindow.width = note.width;
		nativeWindow.height = note.height;
		width = note.width;
		height = note.height;
		
		if (_note.background)
			setStyle("backgroundGradient", _note.background.gradient);
		
		if (textAreaDisplay)
		{
			textAreaDisplay.text = note.text;
			
			if (_note.fontFamily)
				setStyle("fontFamily", _note.fontFamily);
			if (_note.fontSize)
				setStyle("fontSize", _note.fontSize);
		}
	}
	
	/**
	 * @private
	 */
	protected function startResize(edgeOrCorner:String):void
	{
		if (resizable && !nativeWindow.closed)
			stage.nativeWindow.startResize(edgeOrCorner);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Protected :: Handlers
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	protected function mouseMoveHandler(event:MouseEvent):void
	{
		edgeOrCorner = mx_internal::hitTestResizeEdge(event);
		event.updateAfterEvent();
	}
	
	/**
	 * @private
	 */
	protected function updateBoundsHandler(event:NativeWindowBoundsEvent):void
	{
		if (!_note)
			return;
		
		_note.x = nativeWindow.x;
		_note.y = nativeWindow.y;
		_note.width = nativeWindow.width;
		_note.height = nativeWindow.height;
	}
	
	/**
	 * @private
	 */
	protected function textAreaDisplay_changeHandler(event:TextOperationEvent):void
	{
		dispatchEvent(new NotePadEvent(NotePadEvent.TEXT_CHANGE, false, false, this));
	}
	
	/**
	 * @private
	 */
	protected function passThruHandler(event:NotePadEvent):void
	{
		dispatchEvent(event);
	}
}
}