namespace :deploy do
  namespace :nginx do
    task :start, :roles => :web do
      sudo "/etc/rc.d/nginx start" 
    end

    task :stop, :roles => :web do
      sudo "/etc/rc.d/nginx stop" 
    end

    task :restart, :roles => :web do
      sudo "/etc/rc.d/nginx restart"
    end
    
    task :setup, :roles => :web do
      return unless web_server == :nginx
      if uses_ssl
        deploy.nginx.ssl.setup
      else
        if respond_to?(:rails_env)
          nginx_rails_env = rails_env || "production"
        else
          nginx_rails_env = "production"
        end
        nginx_config_file = <<-EOF
            upstream #{application}_server {
              server unix:#{deploy_to}/tmp/sockets/unicorn.sock fail_timeout=0;
            }
            server {
              listen #{web_port};

              client_max_body_size 4G;
              server_name #{domain};

              keepalive_timeout 5;

              root #{deploy_to}/current/public;

              location / {
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

                proxy_set_header Host $http_host;

                proxy_redirect off;

                if (!-f $request_filename) {
                  proxy_pass http://#{application}_server;
                  break;
                }
              }

              error_page 500 502 503 504 /500.html;
              location = /500.html {
                root #{deploy_to}/current/public;
              }

              access_log  /var/log/nginx/#{domain}.access.log;
              error_log  /var/log/nginx/#{domain}.error.log;

            }
        EOF
        sudo_put nginx_config_file, "#{nginx_conf_dir}/#{application}_#{nginx_rails_env}.conf"
      end
    end
    namespace :ssl do
      task :setup, :roles => :web do
        if respond_to?(:rails_env)
          nginx_rails_env = rails_env || "production"
        else
          nginx_rails_env = "production"
        end
        nginx_config_file = <<-EOF
          server {
            listen   443;
            passenger_enabled on;

            ssl                  on;          
            ssl_certificate      #{deploy_to}/shared/certificates/#{domain}.crt.merged;
            ssl_certificate_key  #{deploy_to}/shared/certificates/#{domain}.key;
            ssl_session_timeout  5m;
            ssl_protocols  SSLv3 TLSv1;
            ssl_ciphers  ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+EXP;
            ssl_prefer_server_ciphers   on;

            keepalive_timeout    70;
            client_max_body_size 50M;
            server_name www.#{domain} #{domain};
            root #{deploy_to}/current/public;
            access_log  /var/log/nginx/#{domain}.access.log;
            error_log  /var/log/nginx/#{domain}.error.log;

            if (-f $document_root/system/maintenance.html) {
              rewrite  ^(.*)$  /system/maintenance.html last;
              break;
            }

            error_page   500 502 503 504  /500.html;
            location = /500.html {
              root   #{deploy_to}/current/public;
            }
          }

          server {
            listen   80;
            passenger_enabled on;
            client_max_body_size 50M;
            server_name www.#{domain} #{domain};
            rewrite ^/(.*) https://#{domain}/$1 permanent;
          }
        EOF
        sudo_put nginx_config_file, "#{nginx_conf_dir}/#{application}_#{nginx_rails_env}.conf"
      end
    end
  end
end
