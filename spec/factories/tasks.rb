FactoryBot.define do
  factory :task do
    title 'Task title'
    description 'Task description'
    deadline Time.current.since(1.day)
    priority Task.priorities[:medium]
    status Task.statuses[:todo]

    trait :low do
      priority Task.priorities[:low]
    end
    trait :medium do
      priority Task.priorities[:medium]
    end
    trait :high do
      priority Task.priorities[:high]
    end
    trait :todo do
      status Task.statuses[:todo]
    end
    trait :doing do
      status Task.statuses[:doing]
    end
    trait :done do
      status Task.statuses[:done]
    end

    trait :with_label do
      after(:build) { |task| task.label_list.add("test_label") }
    end
  end
end
