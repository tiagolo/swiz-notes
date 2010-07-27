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

package swiznotes.chains.steps
{

import mx.core.UIComponent;
import mx.managers.PopUpManager;

import org.swizframework.utils.chain.CommandChainStep;

import swiznotes.model.vo.Note;

/**
 * A command step that opens and closes a NotePad modal screen.
 * 
 * @author Michael Schmalle
 * @source
 */
public class ShowModalStep extends CommandChainStep
{
	//--------------------------------------------------------------------------
	//
	//  Private :: Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private var show:Boolean;
	
	/**
	 * @private
	 */
	private var note:Note;
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function ShowModalStep(show:Boolean, note:Note)
	{
		super();
		
		this.show = show;
		this.note = note;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden Public :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	override public function execute():void
	{
		if (show)
		{
			// add the modal screen in the NotePad
			note.modal = new UIComponent();
			PopUpManager.addPopUp(note.modal, note.window, true);
		}
		else
		{
			// remove the modal screen from the NotePad
			PopUpManager.removePopUp(note.modal);
			note.modal = null;
		}
		
		// move to the next step
		complete();
	}
}
}