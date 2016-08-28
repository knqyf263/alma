require 'alma/error'

module Alma
  class Notification
    class Mail

      def initialize
        require 'net/smtp'
        require 'securerandom'
      end

      def configure
        @cc ||= ""
        @bcc ||= ""

        @out_keys = @out_keys.nil? ? "" : @out_keys.split(',')

        if @out_keys.empty?
          raise Alma::ConfigError, "Either 'out_keys' must be specifed."
        end
      end
      
      def send(record)
        message = create_key_value_message(record)

        begin
          sendmail(@subject, message)
        rescue => e
          "error_class: #{e.class}, error_message: #{e.message}, error_backtrace: #{e.backtrace.first}"
        end
      end

      def create_key_value_message(record)
        values = @out_keys.map do |key|
          "#{key}: #{record[key].to_s}"
        end

        values.join("\n")
      end
    
      def sendmail(subject, msg, dest = nil)
        subject = subject.force_encoding('binary')
        body = msg.force_encoding('binary')

        date = Time.now.strftime("%a, %d %b %Y %X %z")

        mid = sprintf("<%s@%s>", SecureRandom.uuid, SecureRandom.uuid)
        content = <<EOF
From: #{@from}
To: #{@to}
Cc: #{@cc}
Bcc: #{@bcc}
Subject: #{subject}
Date: #{date}
Message-Id: #{mid}
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8

#{body}
EOF
        Net::SMTP.start(@host, @port) do |smtp|
          smtp.send_mail(content, @from, @to.split(','), @cc.split(','), @bcc.split(','))
        end
      end

      def host(host) @host = host end
      def port(port) @port = port end
      def from(from) @from = from end
      def to(to) @to = to end
      def cc(to) @cc = cc end
      def bcc(to) @bcc = bcc end
      def subject(subject) @subject = subject end
      def out_keys(out_keys) @out_keys = out_keys end

    end
  end
end
