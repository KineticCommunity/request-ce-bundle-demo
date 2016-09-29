<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="bundle/initialization.jspf" %>
<bundle:layout page="layouts/layout.jsp">
    <bundle:variable name="head">
        <title>${text.escape(space.name)} Reset Password</title>
    </bundle:variable>

    <div class="login-box-body">
        <!-- Logo -->
        <div class="login-logo">
            <a href="#" class="logo">
                <!-- logo for regular state and mobile devices -->
                <span class="logo-lg"> 
                    <c:choose>
                        <%-- Check to See if Company Logo / Name Attributes Exists --%>
                        <c:when test="${not empty space.getAttribute('Company Logo')}">
                            <img class="" src="${BundleHelper.getLogo()}" alt="logo" style="display:block; max-height:100px; margin-left: auto; margin-right:auto; margin-top: 5px; max-width:300px">
                        </c:when>
                        <%-- If no logo attribute exists, display the Company or KAPP Name --%>
                        <c:otherwise>
                            <c:choose>
                                <c:when test="${not empty space.getAttribute('Company Name') && not empty space.getAttributeValue('Company Name')}">
                                    ${space.getAttributeValue('Company Name')}
                                </c:when>
                                <c:otherwise>
                                    ${space.name}
                                </c:otherwise>
                            </c:choose>
                        </c:otherwise>
                    </c:choose>
                </span>
            </a>
        </div>
        <section>
            <c:choose>
                <c:when test="${param.confirmation == null}">
                    <!-- Password reset -->
                    <form action="<c:url value="/${space.slug}/app/reset-password"/>" method="POST">
                    <c:if test="${param.badtoken != null}">
                        <div class="alert alert-danger">
                            Your password reset token was not valid. Please try again.
                        </div>
                    </c:if>

                    <!-- CSRF Token field -->
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <p class="login-box-msg" style="padding-top:15px;">Enter your username</p>
                    <!-- Email field -->
                    <div class="form-group">
                        <label for="username">
                            ${i18n.translate("Username")}
                        </label>
                        <input type="text" name="username" id="username" class="form-control" autofocus/>
                    </div>

                    <div class="form-group">
                        <button type="submit" class="btn btn-default">${i18n.translate("Reset")}</button>
                        <a href="<c:url value="/${space.slug}/app/reset-password?confirmation"/>">I already have a reset code.</a>
                    </div>
                    </form>
                </c:when>
                <c:otherwise>
                    <!-- Password reset confirmation -->
                    <form action="<c:url value="/${space.slug}/app/reset-password/token"/>" method="POST">
                    <h3>Password Reset</h3>
                    <p>
                        You will receive an email with a unique code which will enable you to reset your password. Type that
                        password into the token field and enter your new desired password.
                    </p>

                    <c:if test="${param.nomatch != null}">
                        <div class="alert alert-danger">
                            Your passwords did not match.
                        </div>
                    </c:if>

                    <!-- CSRF Token field -->
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                    <!-- Token field -->
                    <div class="form-group">
                        <label for="token">
                            ${i18n.translate("Token")}
                        </label>
                        <input type="text" name="token" id="token" class="form-control" autofocus/>
                    </div>

                    <!-- Password field -->
                    <div class="form-group">
                        <label for="password">
                            ${i18n.translate("Password")}
                        </label>
                        <input type="password" name="password" id="password" class="form-control"/>
                    </div>

                    <!-- Password Confirmation field -->
                    <div class="form-group">
                        <label for="confirmPassword">
                            ${i18n.translate("Confirm Password")}
                        </label>
                        <input type="password" name="confirmPassword" id="confirmPassword" class="form-control"/>
                    </div>

                    <div class="form-group">
                        <button type="submit" class="btn btn-default">${i18n.translate("Submit")}</button>
                        <a href="<c:url value="/${space.slug}/app/reset-password"/>">I don't have a reset code.</a>
                    </div>
                    </form>
                </c:otherwise>
            </c:choose>
        </section>
    </div>
</bundle:layout>
