require_relative '../integration_helper'

class UserExerciseTest < Minitest::Test
  include DBCleaner

  def test_archive_and_unarchive
    alice = User.create(username: 'alice')
    exercise = UserExercise.create(user: alice, archived: false)
    exercise.submissions << Submission.create(user: alice) # temporary measure
    refute exercise.archived?

    exercise.archive!
    exercise.reload
    assert exercise.archived?

    exercise.unarchive!
    exercise.reload
    refute exercise.archived?
  end

  def test_nit_count
    alice = User.create!(username: 'alice')
    exercise = UserExercise.create!(
        user: alice,
        submissions: [
            Submission.create!(user: alice, nit_count: 5),
            Submission.create!(user: alice, nit_count: 7)
        ]
    )

    exercise.reload
    assert_equal 12, exercise.nit_count
  end

  def test_current
    alice = User.create(username: 'alice')
    closure_1 = UserExercise.create(user: alice, archived: false, language: 'closure', iteration_count: 1)
    ruby_1 = UserExercise.create(user: alice, archived: false, language: 'ruby', iteration_count: 1)
    closure_2 = UserExercise.create(user: alice, archived: false, language: 'closure', iteration_count: 1)
    ruby_2 = UserExercise.create(user: alice, archived: false, language: 'ruby', iteration_count: 1)
    archived_ruby = UserExercise.create(user: alice, archived: true, language: 'ruby', iteration_count: 1)
    assert_equal UserExercise.current, [closure_1, closure_2, ruby_1, ruby_2]
  end
end

