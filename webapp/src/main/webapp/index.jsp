<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="Register for the DevOps learning community.">
  <title>Join the DevOps Learning Community</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
</head>
<body>
  <main class="page-shell">
    <section class="intro-panel" aria-labelledby="intro-title">
      <p class="eyebrow">VIRTUAL TECHBOX</p>
      <h1 id="intro-title">Build better. Learn together.</h1>
      <p class="intro-copy">Join a practical DevOps learning community focused on automation, cloud delivery, and real project experience.</p>
      <ul class="benefit-list">
        <li><span class="benefit-icon">01</span><span>Learn CI/CD through hands-on projects</span></li>
        <li><span class="benefit-icon">02</span><span>Explore Kubernetes, GitOps, and AWS</span></li>
        <li><span class="benefit-icon">03</span><span>Grow with a community of builders</span></li>
      </ul>
    </section>

    <section class="form-panel" aria-labelledby="form-title">
      <div class="form-heading">
        <p class="eyebrow">CREATE YOUR ACCOUNT</p>
        <h2 id="form-title">Start learning today</h2>
        <p>Complete the form below to register your interest.</p>
      </div>

      <form id="registration-form" action="#" method="post" novalidate>
        <div class="field-row">
          <div class="field-group">
            <label for="full-name">Full name</label>
            <input type="text" id="full-name" name="fullName" placeholder="Ram Kumar" autocomplete="name" required>
          </div>
          <div class="field-group">
            <label for="mobile">Mobile number</label>
            <input type="tel" id="mobile" name="mobile" placeholder="+91 98765 43210" autocomplete="tel" required>
          </div>
        </div>

        <div class="field-group">
          <label for="email">Email address</label>
          <input type="email" id="email" name="email" placeholder="you@example.com" autocomplete="email" required>
        </div>

        <div class="field-row">
          <div class="field-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" placeholder="At least 8 characters" autocomplete="new-password" minlength="8" required>
          </div>
          <div class="field-group">
            <label for="password-confirmation">Confirm password</label>
            <input type="password" id="password-confirmation" name="passwordConfirmation" placeholder="Repeat your password" autocomplete="new-password" minlength="8" required>
          </div>
        </div>

        <label class="consent-row" for="terms">
          <input type="checkbox" id="terms" name="terms" required>
          <span>I agree to the <a href="#terms">Terms &amp; Privacy</a>.</span>
        </label>

        <p class="form-message" id="form-message" role="status" aria-live="polite"></p>
        <button class="register-button" type="submit">Create account <span aria-hidden="true">&#8594;</span></button>
      </form>

      <p class="signin-note">Already registered? <a href="#signin">Sign in</a></p>
    </section>
  </main>

  <script>
    (function () {
      var form = document.getElementById('registration-form');
      var password = document.getElementById('password');
      var confirmation = document.getElementById('password-confirmation');
      var message = document.getElementById('form-message');

      form.addEventListener('submit', function (event) {
        event.preventDefault();
        message.className = 'form-message';

        if (!form.checkValidity()) {
          message.textContent = 'Please complete all required fields.';
          message.classList.add('error-message');
          form.reportValidity();
          return;
        }

        if (password.value !== confirmation.value) {
          message.textContent = 'Passwords do not match. Please try again.';
          message.classList.add('error-message');
          confirmation.focus();
          return;
        }

        message.textContent = 'Your registration details are ready to be submitted.';
        message.classList.add('success-message');
      });
    }());
  </script>
</body>
</html>
