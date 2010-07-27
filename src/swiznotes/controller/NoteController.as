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

import flash.display.Screen;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.TimerEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.geom.Rectangle;
import flash.utils.Timer;

import org.swizframework.events.BeanEvent;
import org.swizframework.utils.logging.SwizLogger;

import swiznotes.components.NotePad;
import swiznotes.config.ApplicationConfig;
import swiznotes.events.NoteEvent;
import swiznotes.events.SwizNotesEvent;
import swiznotes.model.ApplicationModel;
import swiznotes.model.NoteModel;
import swiznotes.model.vo.BackgroundColor;
import swiznotes.model.vo.Note;
import swiznotes.services.FileStorage;
import swiznotes.services.IStorage;
import swiznotes.views.SwizNotePad;

/**
 * The <strong>NoteController</strong> manages the <code>Note</code> level of the
 * SwizNotes application.
 * 
 * <p>The controller is responsible for opening and closing <code>NotePad</code> 
 * windows and restoring and saving <code>Note</code> state.</p>
 * 
 * @author Michael Schmalle
 * @source
 */
public class NoteController
{
	//--------------------------------------------------------------------------
	//
	//  Protected :: Constants
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	protected static const BACKUP_FILE_NAME:String = "fileBackup.xml";
	
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
	public var applicationConfig:ApplicationConfig;
	
	[Inject]
	public var noteModel:NoteModel;
	
	[Inject]
	public var storage:IStorage;
	
	//--------------------------------------------------------------------------
	//
	//  Protected :: Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	protected var logger:SwizLogger = SwizLogger.getLogger(this);
	
	/**
	 * @private
	 */
	private var backupStorage:IStorage;
	
	/**
	 * @private
	 */
	private var backupTimer:Timer;
	
	//--------------------------------------------------------------------------
	//
	//  Public State API :: Methods
	//
	//--------------------------------------------------------------------------
	
	[Mediate(event="NoteEvent.SAVE_NOTE_AS_REQUESTED",properties="note")]
	/**
	 * 
	 */
	public function saveNoteAs(note:Note):void
	{
		var file:File = File.desktopDirectory;
		file.addEventListener(Event.SELECT, file_selectHandler);
		file.browseForSave("Save note");
	}
	
	[Mediate(event="SwizNotesEvent.RESTORE_STATE")]
	/**
	 * Restores the state of the application.
	 */
	public function restoreState():void
	{
		if (applicationModel.initialized)
			return;
		
		logger.info("Restoring application state");
		
		var memento:XML = getMemento();
		var backupMemento:XML = getBackupMemento();
		var selectedNote:Note = null;
		
		// compare the 2 time stamps, take the one that is greater
		if (backupMemento != null)
		{
			if (Number(backupMemento.timestamp) > Number(memento.timestamp))
				memento = backupMemento;
		}
		
		var noteMementos:XMLList = memento..note;
		
		if (noteMementos.length() == 0)
		{
			selectedNote = new Note();
			
			// no Notes, so the first we create will be centered on the main screen
			// and selected (focused and caret in the TextArea ready for text entry)
			var screen:Rectangle = Screen.mainScreen.bounds;
			
			// calculate the center of the mainScreen
			selectedNote.x = Math.floor((screen.width - selectedNote.width) / 2);
			selectedNote.y = Math.floor((screen.height - selectedNote.height) / 2);
			
			selectedNote.selected = true;
			
			// add the Note to the dataProvider
			addNote(selectedNote);
		}
		else
		{
			for each (var node:XML in memento..note)
			{
				var note:Note = new Note();
				
				addNote(note);
				
				restoreNote(note, node);
				
				if (note.selected)
					selectedNote = note;
			}
		}
		
		// OpenNotesStep || NoteEvent.NOTE_OPEN
		var len:int = noteModel.dataProvider.length;
		for (var i:int = 0; i < len; i++)
		{
			openNote(noteModel.dataProvider[i]);
		}
		
		// SelectNoteStep || NoteEvent.NOTE_CHANGE_REQUESTED
		if (selectedNote)
		{
			dispatcher.dispatchEvent(new NoteEvent(
				NoteEvent.NOTE_CHANGE_REQUESTED, selectedNote));
		}
		
		dispatcher.dispatchEvent(new SwizNotesEvent(
			SwizNotesEvent.RESTORE_STATE_COMPLETE));
		
		logger.info("Application state restored");
	}
	
	[Mediate(event="SwizNotesEvent.SAVE_STATE")]	
	/**
	 * Saves the state of the application.
	 */
	public function saveState():void
	{
		logger.info("Saving application state");
		
		var memento:XML = new XML("<notes/>");
		memento.timestamp = new Date().getTime();
		
		var len:int = noteModel.dataProvider.length;
		for (var i:int = len - 1; i >= 0; i--)
		{
			saveNote(noteModel.dataProvider[i], memento);
		}
		
		storage.saveStorage(memento.toXMLString());
		
		if (backupStorage)
		{
			backupStorage.saveStorage(memento.toXMLString());
		}
		
		dispatcher.dispatchEvent(new SwizNotesEvent(
			SwizNotesEvent.SAVE_STATE_COMPLETE));
		
		logger.info("Application state saved");
	}
	
	[Mediate(event="SwizNotesEvent.SAVE_BACKUP_STATE")]	
	/**
	 * Saves the backup state of the application.
	 */
	public function saveBackupState():void
	{
		logger.info("Saving backup state");
		
		var memento:XML = new XML("<notes/>");
		memento.timestamp = new Date().getTime();
		
		var len:int = noteModel.dataProvider.length;
		for (var i:int = len - 1; i >= 0; i--)
		{
			saveNote(noteModel.dataProvider[i], memento);
		}
		
		backupStorage.saveStorage(memento.toXMLString());
		
		dispatcher.dispatchEvent(new SwizNotesEvent(
			SwizNotesEvent.SAVE_BACKUP_STATE_COMPLETE));
		
		logger.info("Backup state saved");
	}
	
	[Mediate(event="SwizNotesEvent.APPLICATION_CLOSE")]
	/**
	 * Closes and saves all Notes of the application.
	 */
	public function closeNotes():void
	{
		var len:int = noteModel.dataProvider.length;
		for (var i:int = len - 1; i >= 0; i--)
		{
			closeNote(noteModel.dataProvider[i]);
		}
	}
	
	[Mediate(event="NoteEvent.NOTE_CREATE")]
	/**
	 * Creates a new note from scratch and opens it.
	 */
	public function createNote():void
	{
		logger.info("Create Note");
		
		var note:Note = new Note();
		addNote(note);
		
		if (noteModel.currentItem)
		{
			// advance note bounds reletive to the currentItem (the note
			// that just created this new Note)
			note.x = noteModel.currentItem.window.nativeWindow.x + 50;
			note.y = noteModel.currentItem.window.nativeWindow.y + 50;
			
			// copy the current color
			note.background = noteModel.currentItem.background;
			
			note.fontFamily = noteModel.currentItem.fontFamily;
			note.fontSize = noteModel.currentItem.fontSize;
		}
		
		openNote(note);
	}
	
	[Mediate(event="NoteEvent.NOTE_OPEN", properties="note")]
	/**
	 * Creates a new NotePad window using the note and opens it.
	 * 
	 * @param note An existing Note in the collection.
	 */
	public function openNote(note:Note):void
	{
		if (note.window)
		{
			logger.warn("Trying to open an already open window");
			return;
		}
		
		logger.info("Open Note");
		
		// create the NativeWindow NotePad
		var window:NotePad = createWindow(note);
		// open the NativeWindow NotePad
		window.open();
		
		logger.info("Note opened");
	}
	
	[Mediate(event="NoteEvent.NOTE_CLOSE_REQUESTED",properties="note")]
	/**
	 * 
	 */
	public function closeNote(note:Note):void
	{
		logger.info("Closing Note");
		
		// remove the note from notes
		if (!noteModel.dataProvider.contains(note))
		{
			logger.error("Note does not exists in dataProvider");
			return;
		}
		
		// remove the Note from the dataProvider
		removeNote(note);
		
		// this will close the nativeWindow if not already closed by a closeButton click
		if (!note.window.closed)	
			dispatcher.dispatchEvent(new NoteEvent(NoteEvent.NOTE_CLOSE_NOTE_PAD, note));
		
		// notify listeners that a Note has closed successfully
		dispatcher.dispatchEvent(new NoteEvent(NoteEvent.NOTE_CLOSE_COMPLETE, note));
		// remove the Note Bean from the BeanFactory
		dispatcher.dispatchEvent(new BeanEvent(BeanEvent.TEAR_DOWN_BEAN, note.window));
		
		logger.info("Note closed");
	}
	
	[Mediate(event="NoteEvent.NOTE_CHANGE_REQUESTED", properties="note")]
	/**
	 * 
	 */
	public function setCurrentItem(note:Note):void
	{
		if (noteModel.currentItem == note)
			return;
		
		// update the NoteModel with it's current Note
		noteModel.currentItem = note;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Protected :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Restores a NotePad from and XML memento.
	 * 
	 * @param note A Note instance to load.
	 * @param memento A Note XML memento node.
	 */
	protected function restoreNote(note:Note, memento:XML):void
	{
		logger.info("Restoring Note");
		
		// restore the Note vo from the XML memento
		note.x = memento.@x;
		note.y = memento.@y;
		note.width = memento.@width;
		note.height = memento.@height;
		
		var b:String = memento.@background;
		if (b != null && b != "")
		{
			// if a BackgroundColor has been saved for the Note, push into vo
			note.background = getBackground(b);
		}
		
		note.text = memento.text;
		
		if (memento.@fontFamily != "")
			note.fontFamily = memento.@fontFamily;
		else
			note.fontFamily = "Arial";
		
		if (memento.@fontSize != "")
			note.fontSize = memento.@fontSize;
		else
			note.fontSize = 12;
		
		// remember the last selected (focused) Note
		note.selected = (memento.@selected == "true");
	}
	
	/**
	 * Saves a NotePad to an XML memento.
	 * 
	 * @param note A Note instance to save.
	 * @param memento A Note XML memento parent node.
	 */
	protected function saveNote(note:Note, memento:XML):void
	{
		logger.info("Saving Note");
		
		// save the Note vo into the XML memento
		var xml:XML = new XML("<note/>");
		xml.@x = note.x;
		xml.@y = note.y;
		xml.@width = note.width;
		xml.@height = note.height;
		
		if (note == noteModel.currentItem)
			xml.@selected = true;
		
		// for now, save the BackgroundColor by name
		xml.@background = note.background.name;
		
		xml.text = note.text;
		xml.@fontFamily = note.fontFamily;
		xml.@fontSize = note.fontSize;
		
		// add the note memento to it's parent <notes/> tag
		memento.appendChild(xml);
	}
	
	/**
	 * @private
	 */
	protected function createWindow(note:Note):NotePad
	{
		// create a new NotePad
		var window:SwizNotePad = new SwizNotePad();
		// inject and mediate
		dispatcher.dispatchEvent(new BeanEvent(BeanEvent.SET_UP_BEAN, window));
		// pass the vo to the component
		window.note = note;
		
		// set a default BackgroundCOlor (White)
		if (!note.background)
			note.background = noteModel.colorProvider[0];
		
		return window;
	}
	
	/**
	 * @private
	 */
	protected function addNote(note:Note):void
	{
		noteModel.dataProvider.addItem(note);
	}
	
	/**
	 * @private
	 */
	protected function removeNote(note:Note):void
	{
		noteModel.dataProvider.removeItemAt(
			noteModel.dataProvider.getItemIndex(note));
	}
	
	/**
	 * @private
	 */
	protected function getMemento():XML
	{
		var memento:XML = new XML();
		
		var data:String = storage.loadStorage();
		if (data != null && data != "")
		{
			memento = new XML(data);
		}
		
		return memento;
	}
	
	/**
	 * @private
	 */
	protected function getBackupMemento():XML
	{
		var memento:XML;
		var backupData:String;
		
		// if the config says autoSave
		if (applicationConfig.autoSave)
		{
			// create the backup storage
			backupStorage = new FileStorage();
			backupStorage.name = BACKUP_FILE_NAME;
			
			// create a timer that will save every n milliseconds
			backupTimer = new Timer(applicationConfig.autoSaveDuration, 0);
			backupTimer.addEventListener(
				TimerEvent.TIMER, backupTimer_timerCompleteHandler);
			
			// try to load a previous backup
			backupData = backupStorage.loadStorage();
			
			// TODO this should be in a complete handler
			// start the timer
			backupTimer.start();
		}
		
		// create the backup memento if previously exists
		if (backupData != null && backupData != "")
			memento = new XML(backupData);
		
		return memento;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Private :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private function getBackground(name:String):BackgroundColor
	{
		var len:int = noteModel.colorProvider.length;
		for (var i:int = 0; i < len; i++)
		{
			var element:BackgroundColor = noteModel.colorProvider[i] as BackgroundColor;
			if (element.name == name)
				return element;
		}
		
		return null;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Private :: Handlers
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private function backupTimer_timerCompleteHandler(event:TimerEvent):void
	{
		dispatcher.dispatchEvent(new SwizNotesEvent(SwizNotesEvent.SAVE_BACKUP_STATE));
	}
	
	/**
	 * @private
	 */
	private function file_selectHandler(event:Event):void
	{
		var file:File = event.target as File;
		var stream:FileStream = new FileStream();
		stream.open(file, FileMode.WRITE);
		stream.writeUTFBytes(noteModel.currentItem.text);
		stream.close();
		
		dispatcher.dispatchEvent(new NoteEvent(
			NoteEvent.SAVE_NOTE_AS_COMPLETE, noteModel.currentItem));
	}
}
}