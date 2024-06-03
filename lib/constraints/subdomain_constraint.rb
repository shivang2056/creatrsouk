class SubdomainConstraint
  def self.matches?(request)
    Store.find_by_request(request).present?
  end
end
