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

package swiznotes.services
{

/**
 * A singular storage container.
 * 
 * <p>The concrete implementation actually determines how the String data
 * is saved to the storage <code>name</code> source.</p>
 * 
 * @author Michael Schmalle
 */
public interface IStorage
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * The name of the storage File.
	 */
	function get name():String;
	
	/**
	 * @private
	 */	
	function set name(value:String):void;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Loads and returns the String data from it's storage source.
	 */
	function loadStorage():String;
	
	/**
	 * Saves the String to it's storage source.
	 * 
	 * @param data A String to be saved to storage.
	 */
	function saveStorage(data:String):void;
	
	/**
	 * Deletes the storage from it's storage source.
	 */
	function deleteStorage():void;
}
}