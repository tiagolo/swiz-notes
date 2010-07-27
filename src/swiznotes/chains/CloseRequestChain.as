package swiznotes.chains
{

import flash.events.IEventDispatcher;

import org.swizframework.utils.chain.CommandChain;

import swiznotes.model.vo.Note;
import swiznotes.views.ConfirmDialog;
import swiznotes.chains.steps.ShowModalStep;
import swiznotes.chains.steps.OpenCloseConfirmDialogStep;

public class CloseRequestChain extends CommandChain
{
	public var dialog:ConfirmDialog;
	
	public var dispatcher:IEventDispatcher;
	
	public var note:Note;
	
	public function CloseRequestChain(dispatcher:IEventDispatcher, note:Note)
	{
		super();
		
		this.dispatcher = dispatcher;
		this.note = note;
	}
	
	override public function start():void
	{
		initialize();
		
		super.start();
	}
	
	protected function initialize():void
	{
		addCommand(new ShowModalStep(true, note));
		addCommand(new OpenCloseConfirmDialogStep(dispatcher, note));
		addCommand(new ShowModalStep(false, note));
	}
}
}