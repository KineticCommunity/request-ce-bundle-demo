<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="../bundle/initialization.jspf" %>

<bundle:layout page="${bundle.path}/layouts/layout.jsp">
    <bundle:variable name="head">
        <title>${text.escape(kapp.name)} Work Order</title>
    </bundle:variable>
    <section class="content-header">
        <span class="small-box-custom bg-maroon">
            <h1><i class="fa fa-tasks"></i> My Tasks</h1>
        </span>
        <ol class="breadcrumb">
            <li>
                <a href="${bundle.kappLocation}"><i class="fa fa-home"></i> Home</a>
            </li>
            <li class="active">My Tasks</li>
        </ol>
    </section>
    <section class="content">
        <div class="nav-tabs-custom ">
            <ul class="nav nav-tabs" role="tablist">
                <li role="presentation" class="active">
                    <a href="#tab_1" data-toggle="tab" role="tab" aria-expanded="false">Open</a>
                </li>
                <li role="presentation">
                    <a href="#tab_2" data-toggle="tab" role="tab" aria-expanded="false">Closed</a>
                </li>
            </ul>
            <div class="tab-content"><div role="tabpanel" class="tab-pane active" id="tab_1">     
                <table id="openTable" class="table table-hover" width="100%"> 

                </table>
            </div><!-- End Tab 1 -->
            <div role="tabpanel" class="tab-pane" id="tab_2">
                <table id="closedTable" class="table table-hover" width="100%">  

                </table>
            </div><!-- End Tab 2 -->
            </div>
        </div>
    </section>
</bundle:layout>
