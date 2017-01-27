<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="../bundle/initialization.jspf" %>

<!-- PRODUCT LIST -->
<div class="box box-primary">
   <div class="box-header with-border">
      <h3 class="box-title">Suggested Services</h3>
      <div class="box-tools pull-right">
         <button class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i></button>
      </div>
   </div><!-- /.box-header -->
   <div class="box-body">
      <ul class="products-list product-list-in-box">
         <c:choose>
            <c:when test="${fn:length(kapp.getCategory('promoted-requests').forms) > 0}">
               <c:forEach var="popForm" begin="0" end="4" items="${kapp.getCategory('promoted-requests').forms}">
                  <li class="item">
                     <div class="product-img">
                        <c:choose>
                           <c:when test="${not empty popForm.getAttributeValue('Image')}">
                              <img src="${bundle.location}/images/forms/${popForm.getAttributeValue('Image')}"  alt="${text.escape(popForm.name)}"/>
                           </c:when>
                           <c:when test="${not empty popForm.getAttributeValue('Icon')}">
                              <i class="fa ${popForm.getAttributeValue('Icon')}"></i>
                           </c:when>
                        </c:choose>
                     </div>
                     <div class="product-info">
                        <a href="${bundle.spaceLocation}/${kapp.slug}/${popForm.slug}" class="product-title">${text.escape(popForm.name)} <span class="label label-warning pull-right"></span></a>
                        <span class="product-description">
                           ${text.escape(popForm.description)}
                        </span>
                     </div>
                  </li><!-- /.item -->
               </c:forEach>
            </c:when>
            <c:otherwise>
               <h4>No Suggested Services</h4>
               <a href="#">Suggest a Service</a>
            </c:otherwise>
         </c:choose>
      </ul>
   </div><!-- /.box-body -->
   <div class="box-footer text-center">
      <a href="javascript::;" class="uppercase"></a>
   </div><!-- /.box-footer -->
</div><!-- /.box -->
