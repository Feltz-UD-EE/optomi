class AssessmentsController < ApplicationController
  def menu    # shows available procedures, in groups
  end

  def new     # form with all questions  
    @assessment = Assessment.new
    @procedure_groups = current_admin.organization.procedure_groups
  end

  def update
    case params[:commit]
    when "Modify Patient"
      @old_assessment = Assessment.find(params[:assessment][:id])
      @assessment = @old_assessment.dup
      @questions = @assessment.procedure.questions
      @answer_array = @old_assessment.assessment_answers
      @answer_array.each do |a|
        @assessment.assessment_answers.build(:possible_answer_id => a.possible_answer_id)
      end
      @old_assessment.delete
      render :new_two and return
    when "New Patient"
      @assessment = Assessment.new
      @procedure_groups = current_admin.organization.procedure_groups
      render :new and return
    when /Attach/
      @assessment = Assessment.find(params[:id])
      if @assessment.patient_id.nil?
        @assessment.update_attribute(:patient_id, params[:assessment][:patient_id])
        redirect_to patient_path(params[:assessment][:patient_id])
      else
        flash[:error] = "Assessment already attached to another patient"
        redirect_to root_path
      end
    when /Detach/
      if current_admin
        assessment = Assessment.find(params[:assessment][:id])
        old_patient_id = assessment.patient_id
        assessment.update_attribute(:patient_id, nil)
        redirect_to patient_path(old_patient_id)  
      end
    else    #refer aka enroll    
      @assessment = Assessment.find(params[:assessment][:id])
      @assessment.update_attribute(:referral, true)

      flash[:notice] = "Success"
      redirect_to root_path
    end
  end
  
  def index   # list (patient-specific) existing assessments
    if current_patient && !is_admin
      @assessments = current_patient.assessments.date_order
    elsif admin_has_perms(:v_my_assessments) && params[:set] != 'open'     # surgeon or assessor
      @assessments = current_admin.assessments.date_order
      @title = 'my assessments'
    else                                                                                     # clinician, including assessor
      @assessments = Assessment.unattached.for_org(current_admin.organization_id).referral_order
      @title = 'open assessments'
    end
  end

  def show    # show (patient-specific) existing assessment
    if (current_patient && current_patient.assessments.map(&:id).include?(params[:id].to_i)) ||
       (admin_has_perms(:v_my_assessments) && current_admin.assessments.map(&:id).include?(params[:id].to_i)) ||
       (admin_has_perms(:cr_patient) && Assessment.for_org(current_admin.organization_id).map(&:id).include?(params[:id].to_i))
      @assessment = Assessment.find(params[:id])
    else
      flash[:error] = "No such assessment"
      redirect_to root_path
    end
  end

  def new_two
    @assessment = Assessment.new(:procedure_id => params[:assessment][:procedure_id].to_i, :admin_id => current_admin.id, :patient_name => params[:assessment][:patient_name])
    @procedure_groups = current_admin.organization.procedure_groups
    
    verify_patient_name; return if performed?
    verify_procedure_chosen; return if performed?

    @assessment.procedure.questions.each do |q|
      @assessment.assessment_answers.build(:possible_answer_id => q.default_answer)
    end
    @questions = @assessment.procedure.questions
    render :new_two
  end
  
  def new_three
    if params[:commit] == "Back"
      @assessment = Assessment.new(:procedure_id => params[:assessment][:procedure_id].to_i, :admin_id => current_admin.id, :patient_name => params[:assessment][:patient_name])
      @procedure_groups = current_admin.organization.procedure_groups
      render new_assessment_path(@assessment) and return
    end
  
    @answer_array = params[:assessment].delete("assessment_answers_attributes")
    @patient_id = params[:assessment].delete("patient_id")
    @assessment = Assessment.new(params[:assessment])
    
    verify_all_questions_answered; return if performed?
    verify_patient_age; return if performed?
    
    @assessment.patient_id = @patient_id unless @patient_id.nil?   
    @assessment.save                             
    @assessment.update_attribute(:risk_calculated, 0)   # also saves dependent models
    @assessment.calculate_raws
    @assessment.calculate_percentiles
    @assessment.calculate_aggregate_score
    render layout: "assessment_result_layout"
  end
  
  def refer   # saves referral flag
  end

  def detach
    binding.pry
    assessment = Assessment.find(params[:assessment_id])
    old_patient_id = assessment.patient_id
    assessment.update_attribute(:patient_id, nil)
    redirect_to patient_path(old_patient_id)
  end
  
  private
  
  def verify_patient_name
    if @assessment.patient_name.blank?
      flash[:error] = "Patient name can't be blank."
      render new_assessment_path(@assessment) and return
    end 
  end
  
  def verify_procedure_chosen
    if @assessment.procedure_id.blank? || @assessment.procedure_id == 0
      flash[:error] = "You must choose a procedure."
      render new_assessment_path(@assessment) and return
    end 
  end
  
  def verify_patient_age
    if !@assessment.valid? && @assessment.errors[:patient_age].any?
      render new_two_assessments_path(@assessment) and return
    end 
  end
  
  def verify_all_questions_answered
    @questions = @assessment.procedure.questions
    if @answer_array.nil? || @answer_array.length != @questions.length
      flash[:error] = "You must answer all questions."
      @questions.each_with_index do |q, i|
        if @answer_array.nil? || @answer_array[i.to_s].nil?
          @assessment.assessment_answers.build
        else
          @assessment.assessment_answers.build(:possible_answer_id => @answer_array[i.to_s][:possible_answer_id].to_i)
        end
      end
      render new_two_assessments_path(@assessment) and return      
    else
      @answer_array.each do |a|
        @assessment.assessment_answers.build(:possible_answer_id => a[1][:possible_answer_id].to_i)
      end
    end                                
  end

end
