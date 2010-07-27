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

package swiznotes.presentation
{

import flash.display.DisplayObject;
import flash.display.NativeMenu;
import flash.display.NativeMenuItem;
import flash.events.ContextMenuEvent;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

import org.swizframework.events.ChainEvent;
import org.swizframework.utils.logging.SwizLogger;

import swiznotes.chains.CloseRequestChain;
import swiznotes.components.NotePad;
import swiznotes.core.mediate_handler;
import swiznotes.events.NoteEvent;
import swiznotes.events.SwizNotesEvent;
import swiznotes.model.ApplicationModel;
import swiznotes.model.NoteModel;
import swiznotes.model.vo.BackgroundColor;
import swiznotes.model.vo.Note;
import swiznotes.model.vo.NotePadContextMenuData;
import swiznotes.util.NotePadUtil;

/**
 * The NotePadManager manages all NotePad windows.
 * 
 * <p>This manager could be called the NotePadPresentation but, since it actually
 * manages all instances of NotePad and not per instance, manager seems more 
 * of a descriptive name.</p>
 * 
 * @author Michael Schmalle
 */
public class NotePadManager
{
	//--------------------------------------------------------------------------
	//
	//  Public :: Variables
	//
	//--------------------------------------------------------------------------
	
	[Dispatcher]
	public var dispatcher:IEventDispatcher;
	
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
	public function NotePadManager()
	{
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//  mediate_handler :: Handlers
	//
	//--------------------------------------------------------------------------
	
	[Mediate(event="NotePadEvent.CONTEXT_MENU_CONTRIBUTE", properties="notePad,menu")]
	/**
	 * @see swiznotes.events.NotePadEvent#CONTEXT_MENU_CONTRIBUTE
	 */
	mediate_handler function contextMenuContributeHandler(notePad:NotePad, 
														  menu:ContextMenu):void
	{
		// add weak so when the menu is gone, it won't hang on to us
		menu.addEventListener(
			ContextMenuEvent.MENU_SELECT, 
			menu_menuSelectHandler, false, 0, true);
		
		// add the Exit menu item
		var exitItem:ContextMenuItem = new ContextMenuItem("Exit");
		exitItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menu_exitHandler);
		
		// add the Save As... menu item
		var saveAsItem:ContextMenuItem = new ContextMenuItem("Save As...");
		saveAsItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menu_saveAsHandler);
		
		// add the Choose Font menu item
		var fontItem:ContextMenuItem = new ContextMenuItem("Font");
		fontItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menu_fontFamilyHandler);
		fontItem.separatorBefore = true;
		
		var sub1:NativeMenu = new NativeMenu();
		fontItem.submenu = sub1;
		fillFontFamilies(notePad, sub1);
		
		// add the Choose Font menu item
		var fontSizeItem:ContextMenuItem = new ContextMenuItem("Font Size");
		fontSizeItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menu_fontSizeHandler);
		
		var sub2:NativeMenu = new NativeMenu();
		fontSizeItem.submenu = sub2;
		fillFontSizes(notePad, sub2);
		
		// if there have been items added before us, put a separator, else we are first
		if (menu.customItems.length > 0)
			exitItem.separatorBefore = true;
		
		menu.customItems.push(exitItem);
		menu.customItems.push(saveAsItem);
		
		menu.customItems.push(fontItem);
		menu.customItems.push(fontSizeItem);
		
		// add the background color items
		var len:int = noteModel.colorProvider.length;
		for (var i:int = 0; i < len; i++)
		{
			var item:ContextMenuItem = createColorMenuItem(
				notePad.note, BackgroundColor(noteModel.colorProvider[i]));
			if (i == 0)
				item.separatorBefore = true;
			
			menu.customItems.push(item);
		}
	}
	
	private function fillFontFamilies(notePad:NotePad, menu:NativeMenu):void
	{
		var len:int = noteModel.fontFamilyProvider.length;
		for (var i:int = 0; i < len; i++)
		{
			var fontFamily:String = noteModel.fontFamilyProvider[i] as String;
			var item:NativeMenuItem = new NativeMenuItem(fontFamily);
			if (notePad.note.fontFamily == fontFamily)
				item.checked = true;
			menu.addItem(item);
			menu.addEventListener("select", menu_fontFamilyHandler);
		}
	}
	
	private function fillFontSizes(notePad:NotePad, menu:NativeMenu):void
	{
		var len:int = noteModel.fontSizeProvder.length;
		for (var i:int = 0; i < len; i++)
		{
			var fontSize:Number = noteModel.fontSizeProvder[i];
			var item:NativeMenuItem = new NativeMenuItem(fontSize.toString());
			if (notePad.note.fontSize == fontSize)
				item.checked = true;
			menu.addItem(item);
			menu.addEventListener("select", menu_fontSizeHandler);
		}
	}
	
	[Mediate(event="SwizNotesEvent.DISPLAY_STATE_CHANGE")]
	/**
	 * @see swiznotes.events.SwizNotesEvent#DISPLAY_STATE_CHANGE
	 */
	mediate_handler function displayStateChangeHandler():void
	{
		var len:int = noteModel.dataProvider.length;
		for (var i:int = 0; i < len; i++)
		{
			var note:Note = noteModel.dataProvider[i] as Note;
			
			if (applicationModel.displayState == "minimized")
			{
				note.window.visible = false;
			}
			else
			{
				note.window.visible = true;
			}
		}
	}
	
	[Mediate(event="NoteEvent.NOTE_CHANGE", properties="note")]
	/**
	 * @see swiznotes.events.NoteEvent#NOTE_CHANGE
	 */
	mediate_handler function noteChangeHandler(note:Note):void
	{
		note.window.textAreaDisplay.setFocus();
	}
	
	private var closeRequestChain:CloseRequestChain;
	
	[Mediate(event="NoteEvent.NOTE_CLOSE_CLICK_REQUESTED",properties="note")]
	/**
	 * 
	 */
	mediate_handler function closeClickRequestedHandler(note:Note):void
	{
		if (closeRequestChain)
		{
			closeRequestChain.dialog.activate();
			return;
		}
		
		closeRequestChain = new CloseRequestChain(dispatcher, note);
		closeRequestChain.addEventListener(
			ChainEvent.CHAIN_COMPLETE, closeRequestChain_chainCompleteHandler);
		
		closeRequestChain.start();
	}
	
	private function closeRequestChain_chainCompleteHandler(event:ChainEvent):void
	{
		closeRequestChain = null;
	}
	
	[Mediate(event="NoteEvent.NOTE_CLOSE_NOTE_PAD", properties="note,trigger")]
	/**
	 * @see swiznotes.events.NoteEvent#NOTE_CLOSE_NOTE_PAD
	 */
	mediate_handler function closeNotePadHandler(note:Note, trigger:Event):void
	{
		if (!note.window.closed)
		{
			logger.info("Closing NotePad window programmatically");
			note.window.close();
		}
	}
	
	[Mediate(event="NoteEvent.FONT_FAMILY_CHANGE",properties="note")]
	/**
	 * @see swiznotes.events.NoteEvent#NOTE_CLOSE_NOTE_PAD
	 */
	mediate_handler function fontFamilyChangeHandler(note:Note):void
	{
		logger.info("NotePad fontFamily change '{0}'", note.fontFamily);
		// make menu checked
		note.window.textAreaDisplay.setStyle("fontFamily", note.fontFamily);
	}
	
	[Mediate(event="NoteEvent.FONT_SIZE_CHANGE",properties="note")]
	/**
	 * @see swiznotes.events.NoteEvent#NOTE_CLOSE_NOTE_PAD
	 */
	mediate_handler function fontSizeChangeHandler(note:Note):void
	{
		logger.info("NotePad fontSize change '{0}'", note.fontSize);
		// make menu checked
		note.window.textAreaDisplay.setStyle("fontSize", note.fontSize);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Private :: Handlers
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private function menu_exitHandler(event:ContextMenuEvent):void
	{
		dispatcher.dispatchEvent(new SwizNotesEvent(SwizNotesEvent.APPLICATION_EXIT));
	}
	
	/**
	 * @private
	 */
	private function menu_saveAsHandler(event:ContextMenuEvent):void
	{
		dispatcher.dispatchEvent(new NoteEvent(
			NoteEvent.SAVE_NOTE_AS_REQUESTED, noteModel.currentItem));
	}
	
	/**
	 * @private
	 */
	private function menu_fontFamilyHandler(event:Event):void
	{
		// deselect all items
		deselectMenuItems(event.currentTarget as NativeMenu);
		
		var item:NativeMenuItem = event.target as NativeMenuItem;
		item.checked = true;
		noteModel.currentItem.fontFamily = item.label;
		
		dispatcher.dispatchEvent( new NoteEvent(
			NoteEvent.FONT_FAMILY_CHANGE, noteModel.currentItem));
	}
	
	/**
	 * @private
	 */
	private function menu_fontSizeHandler(event:Event):void
	{
		// deselect all items
		deselectMenuItems(event.currentTarget as NativeMenu);
		
		var item:NativeMenuItem = event.target as NativeMenuItem;
		item.checked = true;
		noteModel.currentItem.fontSize = Number(item.label);
		
		dispatcher.dispatchEvent( new NoteEvent(
			NoteEvent.FONT_SIZE_CHANGE, noteModel.currentItem));
	}
	
	private function deselectMenuItems(menu:NativeMenu):void
	{
		var len:int = menu.items.length;
		for (var i:int = 0; i < len; i++)
		{
			NativeMenuItem(menu.items[i]).checked = false;
		}
	}
	
	/**
	 * @private
	 */
	private function menu_menuSelectHandler(event:ContextMenuEvent):void
	{
		var child:DisplayObject = event.contextMenuOwner;
		var window:NotePad = NotePadUtil.getWindow(child) as NotePad;
		
		dispatcher.dispatchEvent(new NoteEvent(
			NoteEvent.NOTE_CHANGE_REQUESTED, window.note));
	}
	
	/**
	 * @private
	 */
	private function createColorMenuItem(note:Note, 
										 color:BackgroundColor):ContextMenuItem
	{
		var item:ContextMenuItem = new ContextMenuItem(color.name, false, true, true);
		item.data = new NotePadContextMenuData(note, color);
		item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, colorChangeHandler);
		return item;
	}
	
	/**
	 * @private
	 */
	private function colorChangeHandler(event:ContextMenuEvent):void
	{
		var item:ContextMenuItem = event.currentTarget as ContextMenuItem;
		var data:NotePadContextMenuData = item.data as NotePadContextMenuData;
		
		var note:Note = data.note;
		
		// this is needed for the saved state to be correct
		// FIXME this seems wrong 
		note.background = data.color;
		
		note.window.setStyle("backgroundGradient", note.background.gradient);
	}
}
}