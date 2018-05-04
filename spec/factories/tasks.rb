FactoryBot.define do
  factory :task do
    title 'Task title'
    description 'Task description'
    status Task.statuses[:todo]
    priority Task.priorities[:medium]
    deadline Time.current.since(1.day)
  end
end
