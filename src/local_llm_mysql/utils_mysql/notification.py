from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import smtplib

def send_email(subject, body, to_email):
    from_email = "2453939195@qq.com"
    password   = "bajbveysllkjdjbd"

    # 构造邮件
    msg = MIMEMultipart()
    msg['From']    = from_email
    msg['To']      = to_email
    msg['Subject'] = subject
    msg.attach(MIMEText(body, 'plain'))

    try:
        server = smtplib.SMTP('smtp.qq.com', 587)
        server.starttls()
        server.login(from_email, password)
        server.sendmail(from_email, to_email, msg.as_string())
    except Exception as e:
        print(f"Failed to send email: {e}")
    finally:
        server.quit()

if __name__ == '__main__':
    send_email(
        "llmqo API Experiment",
        "The experiment of IMDB XXX finished!",
        "2453939195@qq.com"
    )
