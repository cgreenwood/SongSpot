# Comment
class TracksController < ApplicationController
  before_action all_tasks, only: [:add_favourite]
  def add_favourite
  end
end
