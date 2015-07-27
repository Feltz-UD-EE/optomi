class Assessment < ActiveRecord::Base
  belongs_to :patient
  belongs_to :admin  # surgeon
  belongs_to :procedure
  has_many :assessment_answers
  has_many :possible_answers, through: :assessment_answers
  has_many :questions, through: :assessment_answers
  
  accepts_nested_attributes_for :assessment_answers
  
  attr_accessible :patient_name, :patient_age, :referral, :alos_raw, :alos_percentile, :majcomp_raw, :majcomp_percentile, 
                  :morbidity_raw, :morbidity_percentile, :risk_calculated, :risk_adjusted, :admin_id, :procedure_id, 
                  :created_at, :updated_at
  
  validates :patient_name, :presence => true
  validates :patient_age, :presence => true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: Patient::MAX_AGE }
  validates :admin_id, presence: true
  validates :procedure_id, presence: true

  scope :date_order, -> { order("#{table_name}.created_at DESC")}

  scope :for_org, ->(org_id) {
    if (org_id)
      includes(:admin).where('admins.organization_id' => org_id)   
    end   
  }

  scope :unattached, -> { where('patient_id IS NULL')}
  scope :attached, -> { where('patient_id IS NOT NULL')} 
  
  scope :referral, -> { where('referral IS TRUE')}
  
  scope :referral_order, -> { order("referral, #{table_name}.created_at DESC")}
  
  def calculate_raws
    alos = self.procedure.equations.find_by_equation_type(Equation::TYPES[:alos]).calculate_raw(self)
    majcomp = self.procedure.equations.find_by_equation_type(Equation::TYPES[:major_complication]).calculate_raw(self)
    morbidity = self.procedure.equations.find_by_equation_type(Equation::TYPES[:morbidity]).calculate_raw(self)
    self.update_attribute(:alos_raw, alos) unless alos.nil?
    self.update_attribute(:majcomp_raw, majcomp) unless majcomp.nil?
    self.update_attribute(:morbidity_raw, morbidity) unless morbidity.nil?
  end
  
  def calculate_percentiles
    alos = self.procedure.equations.find_by_equation_type(Equation::TYPES[:alos]).calculate_percentile(self.alos_raw) unless self.alos_raw.nil?
    majcomp = self.procedure.equations.find_by_equation_type(Equation::TYPES[:major_complication]).calculate_percentile(self.majcomp_raw) unless self.majcomp_raw.nil?
    morbidity = self.procedure.equations.find_by_equation_type(Equation::TYPES[:morbidity]).calculate_percentile(self.morbidity_raw) unless self.morbidity_raw.nil?
    self.update_attribute(:alos_percentile, alos) unless self.alos_raw.nil? || alos.nil?
    self.update_attribute(:majcomp_percentile, majcomp) unless self.majcomp_raw.nil? || majcomp.nil?
    self.update_attribute(:morbidity_percentile, morbidity) unless self.morbidity_raw.nil? || morbidity.nil?
  end
  
  def calculate_aggregate_score
    self.update_attribute(:risk_calculated, (self.majcomp_percentile + self.alos_percentile)/2) unless self.majcomp_percentile.nil? || self.alos_percentile.nil?
  end
  
  def to_label
    "#{self.patient_name}: #{self.summary_description}"
  end

  def severity_text
    if self.morbidity_raw.present? && self.morbidity_raw >= 0.06
      "This is a procedure of considerable risk."
    else
      ""
    end
  end

  def displayable_majcomp_raw
    if self.majcomp_raw < 0.01
      "<1"
    else
      (self.majcomp_raw * 100).round.to_s
    end
  end

  def displayable_morbidity_raw
    if self.morbidity_raw < 0.01
      "<1"
    else
      (self.morbidity_raw * 100).round.to_s
    end
  end
  
  def summary_description
    self.procedure.name + " by " + self.admin.user.email + " on " + self.created_at.in_time_zone('Eastern Time (US & Canada)').strftime("%A, %b %d, %Y at %l:%M %P")
  end
end
