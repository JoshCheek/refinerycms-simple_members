module Admin
  class MembersController < Admin::BaseController

    crudify :member,
            :title_attribute => 'first_name', :xhr_paging => true

  end
end
