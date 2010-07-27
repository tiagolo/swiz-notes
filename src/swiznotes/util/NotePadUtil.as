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

package swiznotes.util
{

import flash.display.DisplayObject;

import mx.core.IWindow;

/**
 * Utility methods for the NotePad.
 * 
 * @author Michael Schmalle
 */
public class NotePadUtil
{
	//--------------------------------------------------------------------------
	//
	//  Public Class :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Returns the NotePad from a child of the window.
	 * 
	 * @param The child of the NotePad.
	 * @return A NotePad instance that parents the child somwhere in the display
	 * list, null if the child is not in a IWindow display list.
	 */
	public static function getWindow(child:DisplayObject):IWindow
	{
		var parent:DisplayObject = child.parent;
		
		while (parent && !(parent is IWindow))
			parent = parent.parent;
		
		return IWindow(parent);
	}
}
}