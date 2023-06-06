# frozen_string_literal: true

require 'test_helper'

class AnswersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @answer = answers(:one)
    @question = questions(:one)
    sign_in users(:one)
  end

  test 'should get index' do
    get question_answers_url(question_id: @question)
    assert_response :success
  end

  test 'should get new' do
    get new_question_answer_url(question_id: @question)
    assert_response :success
  end

  test 'should create answer' do
    assert_difference('Answer.count') do
      post question_answers_url(question_id: @question), params: { answer: { name: @answer.name } }
    end

    assert_redirected_to answer_url(Answer.last)
  end

  test 'should show answer' do
    get answer_url(@answer)
    assert_response :success
  end

  test 'should get edit' do
    get edit_answer_url(@answer)
    assert_response :success
  end

  test 'should update answer' do
    patch answer_url(@answer), params: { answer: { name: @answer.name } }
    assert_redirected_to answer_url(Answer.last)
  end

  test 'should destroy answer' do
    assert_difference('Answer.where(status: 2).count', 1) do
      delete answer_url(@answer)
    end

    assert_redirected_to question_answers_url(question_id: @question)
  end
end
