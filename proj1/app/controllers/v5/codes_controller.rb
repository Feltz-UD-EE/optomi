class V5::CodesController < ApplicationController

  def features   #provide all active features for the code
    begin
      code = Code.find(params[:code_id])
    rescue ActiveRecord::RecordNotFound => e
      code = nil
    end
    
    if code.nil?
      handle_standard_error :code_invalid, e
    else
      code_features_array = code.features.map(&:name)

      render json: { features: code_features_array }
    end
  end

  def tracks
    begin
      code = Code.find(params[:code_id])
    rescue ActiveRecord::RecordNotFound => e
      code = nil
    end

    life_condition = Condition.find_by_name("life")
    if code.nil?
      handle_standard_error :code_invalid, e
    else
      code_tracks_array = []
      if code.tracks.any?
        code.code_tracks.each do |ct|
          track = ct.condition
          track.track_uncheckable = ct.uncheckable
          code_tracks_array << track
        end
      else
        code_tracks_array = Condition.where(:is_track => true).order(:track_sort_order)
        code_tracks_array.each do |cta|
          cta.track_uncheckable = !cta.track_uncheckable unless cta.id == life_condition.id
        end
      end
       render json: code_tracks_array 
    end
  end
  
  def show 
    begin
      code = Code.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      code = nil
    end
    
    if code.nil?
      handle_standard_error :code_invalid, e
    else
      render json: code
    end
  end
end
