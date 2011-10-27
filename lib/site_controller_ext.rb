module SimplePassword
  module SiteControllerExt
    def self.included(base)
      base.class_eval {
        include InstanceMethods
        alias_method_chain :process_page, :simple_password
      }
    end

    module InstanceMethods

      protected

      # Process page keeping in count of the presence of a SimplePasswordPage in the ancestors of che currently processed page
      def process_page_with_simple_password(page)
        if simple_password_page = ([page] + page.ancestors).find { |p| p.is_a?(SimplePasswordPage) }
          if authenticate_with_http_basic { |u, p| u == simple_password_page.user && p == simple_password_page.password }
            page.process(request, response)
          else
            request_http_basic_authentication(simple_password_page.realm)
          end
        else
          page.process(request, response)
        end
      end
    end
  end
end
