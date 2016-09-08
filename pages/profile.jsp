<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="../bundle/initialization.jspf" %>
<bundle:layout page="${bundle.path}/layouts/layout.jsp">
    <bundle:variable name="head">
        <title>${text.escape(i18n.translate(space.name))} ${i18n.translate("Profile")}</title>
        <script src="${i18n.scriptPath('shared')}"></script>
        <script src="${i18n.scriptPath('bundle')}"></script>
    </bundle:variable>
    <bundle:scriptpack>
        <bundle:script src="${bundle.location}/js/profile.js" />
    </bundle:scriptpack>
    <div class="container">
        <div class="page-header">
            <h2>${i18n.translate("Edit Your Profile")}</h2>
        </div>
        <p>${i18n.translate("The logged in user Id:")}" ${identity.username}</p>
        <div class="profile panel">
            <div class="panel-body">
                <div class="form-group">
                    <label for="email" class="control-label">${i18n.translate("Email")}</label>
                    <input id="email" name="email" class="form-control" value="${identity.user.email}">
                </div>
                <div class="form-group">
                    <label for="displayName" class="control-label">${i18n.translate("Display Name")}</label>
                    <input id="displayName" name="displayName" class="form-control" value="${identity.user.displayName}">
                </div>
                <c:if test="${ObjectsHelper.hasMethod(identity.user, 'getPreferredLocale')}">
                    <div class="form-group">
                        <label for="displayName" class="control-label">${i18n.translate("Preferred Language")}</label>
                        <select id="preferredLocale" class="form-control">
                            <option></option>
                            <c:forEach var="optionLocale" items="${i18n.getSystemLocales(pageContext.request.locales)}">
                                <option value="${i18n.getLocaleCode(optionLocale)}" 
                                        ${i18n.getLocaleCode(optionLocale) == identity.user.preferredLocale ? 'selected' : ''}
                                    >${text.escape(i18n.getLocaleNameGlobalized(optionLocale))}</option>
                            </c:forEach>
                        </select>
                    </div>
                </c:if>
                <a href="#" id="password-toggle">${i18n.translate("Change Password")}</a>
                <div id="password-section" class="hidden">
                    <div class="form-group">
                        <label for="password" class="control-label">${i18n.translate("Password")}</label>
                        <input id="password" type="password" name="password" class="form-control">
                    </div>
                    <div class="form-group">
                        <label for="passwordConfirmation" class="control-label">${i18n.translate("Password Confirmation")}</label>
                        <input id="passwordConfirmation" type="password" name="passwordConfirmation" class="form-control">
                    </div>
                    <a href="#" id="cancel" class="hidden">${i18n.translate("Cancel")}</a>
                </div>
            </div>
            <div class="panel-footer">
                <button class="btn btn-success save-profile">${i18n.translate("Save")}</button>
            </div>
        </div>
    </div>
</bundle:layout>
