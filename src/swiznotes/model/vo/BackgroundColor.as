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

package swiznotes.model.vo
{

import mx.graphics.LinearGradient;

[DefaultProperty("gradient")]

/**
 * A background color entry used in the NotePad ContextMenu.
 * 
 * @author Michael Schmalle
 */
public class BackgroundColor
{
	//--------------------------------------------------------------------------
	//
	//  Public :: Variables
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	// name
	//----------------------------------
	
	/**
	 * The name of the BackgroundColor.
	 * 
	 * <p>This String will appear in the ContextMenuItem.</p>
	 */
	public var name:String;
	
	//----------------------------------
	// gradient
	//----------------------------------
	
	/**
	 * The linear gradient used when displaying this BackgroundColor.
	 */
	public var gradient:LinearGradient;
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 * 
	 * @param name The name of the color.
	 * @param gradient The linear gradient of the color.
	 */
	public function BackgroundColor(name:String = null, 
									gradient:LinearGradient = null)
	{
		this.name = name;
		this.gradient = gradient;
	}
}
}