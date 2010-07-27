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

package swiznotes.config
{

/**
 * @author Michael Schmalle
 * @source
 */
public class ApplicationConfig
{
	//--------------------------------------------------------------------------
	//
	//  Public :: Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Automatically exits the application if all notes have been closed.
	 */
	public var autoExit:Boolean = true;
	
	/**
	 * Automatically saves the application every x seconds to a temp file.
	 * 
	 * <p>If the application crashes for some reason without exiting properly,
	 * at startup, the application will check to see if there is a temp file,
	 * if there is, the application is restored using this file.</p>
	 */
	public var autoSave:Boolean = false;
	
	/**
	 * The duration at which the application saves the backup file.
	 * 
	 * <p>The <code>autoSave</code> property must be <code>true</code> for
	 * this to work.</p>
	 */
	public var autoSaveDuration:int = 10000;
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function ApplicationConfig()
	{
	}
}
}