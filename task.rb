# Purpose: To contain the attributes of the tasks
class Task
  # What it has
  # id : Integer  - To identify the task uniquely
  # description : String
  # start_date : DateTime
  # target_date : DateTime
  # mark_complete : Boolean
  # completion_date : DateTime
  # status : Symbol :todo :completed :failed
  # frequency : Symbol :off :daily :weekly :monthly :annual
  # reminder_date : DateTime
  # reminder : String
  attr_accessor :description
  attr_accessor :target_date
  attr_accessor :mark_complete
  attr_accessor :completion_date
  attr_accessor :status
  attr_accessor :frequency
  attr_accessor :reminder_date
  attr_accessor :reminder

  # How to describe it
  def initialize(task)
      @description = task[:description]  
      @status = :todo # Status is set to a "todo" upon creation
      @frequency = task[:frequency] || :off
  end

  # What can it do
  # TODO
  # send_message - reminder, notification, encouragement

end