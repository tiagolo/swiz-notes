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

import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

/**
 * An IFileStorage implementation.
 * 
 * @author Michael Schmalle
 */
public class FileStorage implements IStorage
{
	//--------------------------------------------------------------------------
	//
	//  IFileStorage API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _name:String;
	
	/**
	 * @copy swiznotes.services.IStorage#name
	 */
	public function get name():String
	{
		return _name;
	}
	
	/**
	 * @private
	 */	
	public function set name(value:String):void
	{
		_name = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function FileStorage()
	{
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//  IStorage API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy swiznotes.services.IStorage#loadStorage()
	 */
	public function loadStorage():String
	{
		var file:File = File.applicationStorageDirectory.resolvePath(_name);
		var data:String;
		
		var stream:FileStream = new FileStream();
		
		if (file.exists)
		{
			stream.open(file, FileMode.READ);
			data = stream.readUTFBytes(stream.bytesAvailable);
		}
		else
		{
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes("");
		}

		stream.close();
		
		return data;
	}
	
	/**
	 * @copy swiznotes.services.IStorage#saveStorage()
	 */
	public function saveStorage(data:String):void
	{
		var file:File = File.applicationStorageDirectory.resolvePath(_name);
		
		var stream:FileStream = new FileStream();
		stream.open(file, FileMode.WRITE);
		stream.writeUTFBytes(data);
		stream.close();
	}
	
	
	/**
	 * @copy swiznotes.services.IStorage#deleteStorage()
	 */
	public function deleteStorage():void
	{
		var file:File = File.applicationStorageDirectory.resolvePath(_name);
		if (file.exists)
			file.deleteFile();
	}
}
}