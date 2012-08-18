# encoding: utf-8
require 'osaka'

describe "Osaka::TypicalSaveDialog" do

  include(*Osaka::OsakaExpectations)
  subject { Osaka::TypicalSaveDialog.new(at.sheet(1), double("Osaka::RemoteControl").as_null_object)}
  let(:control) { subject.control = double("Osaka::RemoteControl") }
  
  it "Should clone the control and change the window name to Save" do
    app_control = double("Osaka::RemoteControl")
    app_cloned_control = double("Osaka::RemoteControl")
    app_control.should_receive(:clone).and_return(app_cloned_control)
    Osaka::TypicalSaveDialog.new(at.sheet(1), app_control)
  end
  
  it "Should set the filename in the test field" do
    subject.should_receive(:set_filename).with("filename")
    subject.should_receive(:click_save)
    subject.should_not_receive(:set_folder)
    subject.save("filename")
  end
  
  it "Should pick only the base filename when a path is given" do
    subject.should_receive(:set_filename).with("filename")
    subject.should_receive(:set_folder)
    subject.should_receive(:click_save)
    subject.save("/path/filename")
  end
  
  it "Should set the path when a full path is given" do
    control.as_null_object
    subject.should_receive(:set_filename)
    subject.should_receive(:set_folder).with("/path/second")
    subject.save("/path/second/name")
  end
  
  it "Should be able to click save" do
    expect_click(at.button("Save").sheet(1))
    expect_wait_until_not_exists(at.sheet(1))
    subject.click_save
  end
  
  it "Should be able to set the filename" do
    control.should_receive(:set).with('value', at.text_field(1).sheet(1), "filename")
    subject.set_filename("filename")
  end
  
  it "Should be able to set the path" do
    expect_keystroke("g", [ :command, :shift ])
    expect_wait_until_exists(at.sheet(1).sheet(1))
    expect_set("value", at.text_field(1).sheet(1).sheet(1), "path")
    expect_click(at.button("Go").sheet(1).sheet(1))
    expect_wait_until_not_exists(at.sheet(1).sheet(1))
    subject.set_folder("path")
  end

end