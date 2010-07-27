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

import mx.core.UIComponent;

import swiznotes.components.NotePad;

/**
 * @author Michael Schmalle
 */
public class Note
{
	//--------------------------------------------------------------------------
	//
	//  Public :: Variables
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	// x
	//----------------------------------
	
	/**
	 * The x coordinat for the NotePad.
	 */
	public var x:Number = 0;
	
	//----------------------------------
	// y
	//----------------------------------
	
	/**
	 * The y coordinat for the NotePad.
	 */
	public var y:Number = 0;
	
	//----------------------------------
	// width
	//----------------------------------
	
	/**
	 * The width for the NotePad.
	 */
	public var width:Number = 200;
	
	//----------------------------------
	// height
	//----------------------------------
	
	/**
	 * The height for the NotePad.
	 */
	public var height:Number = 200;
	
	//----------------------------------
	// text
	//----------------------------------
	
	/**
	 * The x coordinat e for the NotePad.
	 */
	public var text:String = "";
	
	//----------------------------------
	// fontFamily
	//----------------------------------
	
	/**
	 * The fontFamily for the NotePad.
	 */
	public var fontFamily:String = "Arial";
	
	//----------------------------------
	// fontSize
	//----------------------------------
	
	/**
	 * The fontSize for the NotePad.
	 */
	public var fontSize:Number = 12;
	
	//----------------------------------
	// selected
	//----------------------------------
	
	/**
	 * The selected NotePad.
	 */
	public var selected:Boolean = false;
	
	//----------------------------------
	// background
	//----------------------------------
	
	/**
	 * The x coordinat e for the NotePad.
	 */
	public var background:BackgroundColor;
	
	//----------------------------------
	// window
	//----------------------------------
	
	/**
	 * The NotePad window.
	 */
	public var window:NotePad;
	
	//----------------------------------
	// modal
	//----------------------------------
	
	/**
	 * The NotePad modal screen.
	 */
	public var modal:UIComponent;
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function Note()
	{
		super();
	}
}
}