<!-- This page is used for displaying forms in a uniform way across multiple pages in the catalog
 ** Requirements to use **
    1. A form variable being set (scope=request) before including this page
    2. A service-reviews form to be setup with the following Text Elements (Review / Rating / Form Slug / Form Name)
 -->

<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="../bundle/initialization.jspf" %>

<c:set var="formReviews" value="${SubmissionHelper.retrieveServiceReviews(form.slug)}"/>
<c:set var="reviewsTotal" value="${0}"/>
<c:forEach var="submission" items="${formReviews}">
    <c:set var="reviewsTotal" value="${reviewsTotal + submission.getValue('Rating')}" />
</c:forEach>
<c:set var="reviewsAverage" value="${reviewsTotal/fn:length(formReviews)}"/>


<div class="box box-solid">
    <div class="box-header with-border">
        <h2 class="box-title">${text.escape(form.name)}</h2>
        <a href="${bundle.spaceLocation}/${kapp.slug}/${form.slug}" class="btn btn-primary pull-right">${text.escape('Request')} </a>
    </div>
    <div class="box-body">
        <div class="col-sm-2 formDescription">
            <c:choose>
                <c:when test="${not empty form.getAttributeValue('Image')}">
                    <div class="icon">
                        <img class="img-responsive" src="${bundle.location}/images/forms/${form.getAttributeValue('Image')}"/>
                    </div>
                </c:when>
                <c:when test="${not empty form.getAttributeValue('Icon')}">
                    <div class="icon">
                        <i class="fa ${form.getAttributeValue('Icon')}"></i>
                    </div>
                </c:when>
            </c:choose>
        </div>
        <div class="col-sm-10">
            <dl class="dl-horizontal">
                <dt>Service Description:</dt>
                <dd>${text.escape(form.description)}</dd>
                <dt>Approval Required:</dt>
                <dd>
                    <c:choose>
                        <c:when test="${not empty form.getAttribute('Approval Type').value}">
                            ${form.getAttribute('Approval Type').value}
                        </c:when>
                        <c:otherwise>
                            No Approval Required
                        </c:otherwise>
                    </c:choose>
                </dd>
                <dt>Charge for Service:</dt>
                <dd>
                    <c:choose>
                        <c:when test="${not empty form.getAttribute('Charge').value}">
                            ${form.getAttribute('Charge').value}
                        </c:when>
                        <c:otherwise>
                            Service is Free of Charge
                        </c:otherwise>
                    </c:choose>
                </dd>
                <dt>SLA:</dt>
                <dd>
                    <c:choose>
                        <c:when test="${not empty form.getAttribute('SLA').value}">
                            ${form.getAttribute('SLA').value}
                        </c:when>
                        <c:otherwise>
                            No SLA Defined
                        </c:otherwise>
                    </c:choose>
                </dd>
                <dt>Service Rating:</dt>
                <dd>
                    <a href="#${form.slug}-reviews" data-toggle="collapse">
                        <div class="star star-existing" data-rating='${reviewsAverage}'><span>${fn:length(formReviews)} Review(s) - </span></div> 
                    </a>
                </dd>
            </dl>
        </div>
    </div>
    <div id="${form.slug}-reviews" class="collapse">
        <div class='box-footer box-comments'>
            <c:forEach items="${formReviews}" var="review">
                <div class='box-comment'>
                    <div class='comment-text'>
                        <span class="username">
                            ${space.getUser(review.createdBy).displayName} | <div class="star star-existing" data-rating="${review.getValue('Rating')}"></div>
                            <span data-moment class='text-muted pull-right'>${time.format(review.createdAt)}</span>
                        </span><!-- /.username -->
                        ${text.escape(review.getValue('Review'))}
                    </div><!-- /.comment-text -->
                </div><!-- /.box-comment -->
            </c:forEach>
            <form action="javascript:void(0);">
                <div class="star-new star">Your Rating:  </div>
                <input class="rating" type="hidden">
                <input class="name" type="hidden" value="${form.name}">
                <input class="slug" type="hidden" value="${form.slug}">
                <div class="input-group input-group-sm">
                    <input id="${form.slug}-new-review" type="text" class="form-control input-sm review" placeholder="Submit a new review here">
                    <span class="input-group-btn">
                        <button class="createReview btn btn-danger btn-flat" type="button">Submit!</button>
                    </span>
                </div>
            </form>
        </div><!-- /.box-footer -->
    </div>
</div>