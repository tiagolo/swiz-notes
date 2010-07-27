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

import mx.collections.ArrayCollection;
import mx.collections.IList;

import org.swizframework.utils.logging.SwizLogger;

import swiznotes.events.NoteEvent;
import swiznotes.model.vo.Note;

/**
 * @author Michael Schmalle
 * @source
 */
public class NoteModel
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
	//  dataProvider
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _dataProvider:ArrayCollection = new ArrayCollection();
	
	[Bindable]
	/**
	 * The collection that holds <code>Note</code> instances.
	 * 
	 * @see swiznotes.model.Note
	 */
	public function get dataProvider():ArrayCollection
	{
		return _dataProvider;
	}
	
	/**
	 * @private
	 */	
	public function set dataProvider(value:ArrayCollection):void
	{
		_dataProvider = value;
	}
	
	//----------------------------------
	//  currentItem
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _currentItem:Note;
	
	[Bindable]
	/**
	 * The application's current (focused) <code>Note</code> instance.
	 * 
	 * @event swiznotes.events.NoteEvent#NOTE_CHANGE
	 */
	public function get currentItem():Note
	{
		return _currentItem;
	}
	
	/**
	 * @private
	 */	
	public function set currentItem(value:Note):void
	{
		if (_currentItem == value)
			return;
		
		_currentItem = value;
		
		if (_dataProvider.length > 1)
		{
			// bring this note to the top of the stack
			_dataProvider.removeItemAt(_dataProvider.getItemIndex(_currentItem));
			var topNote:Note = _dataProvider.removeItemAt(_dataProvider.length - 1) as Note;
			
			_dataProvider.addItem(topNote);
			_dataProvider.addItem(_currentItem);
		}
		
		dispatcher.dispatchEvent(
			new NoteEvent(NoteEvent.NOTE_CHANGE, _currentItem));
		
		logger.info("Note change");
	}
	
	//----------------------------------
	//  colorProvider
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _colorProvider:ArrayCollection;
	
	[Bindable]
	/**
	 * The collection that lists <code>BackgroundColor</code>s for the 
	 * <code>NotePad</code>.
	 */
	public function get colorProvider():ArrayCollection
	{
		return _colorProvider;
	}
	
	/**
	 * @private
	 */	
	public function set colorProvider(value:ArrayCollection):void
	{
		_colorProvider = value;
	}
	
	//----------------------------------
	//  fontFamilyProvider
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _fontFamilyProvider:Array;
	
	[Bindable]
	/**
	 * TODO Docme
	 */
	public function get fontFamilyProvider():Array
	{
		return _fontFamilyProvider;
	}
	
	/**
	 * @private
	 */	
	public function set fontFamilyProvider(value:Array):void
	{
		_fontFamilyProvider = value;
	}
	
	//----------------------------------
	//  fontSizeProvder
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _fontSizeProvder:Array;
	
	[Bindable]
	/**
	 * TODO Docme
	 */
	public function get fontSizeProvder():Array
	{
		return _fontSizeProvder;
	}
	
	/**
	 * @private
	 */	
	public function set fontSizeProvder(value:Array):void
	{
		_fontSizeProvder = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function NoteModel()
	{
		super();
	}
}
}