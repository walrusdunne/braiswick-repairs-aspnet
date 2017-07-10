﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RepairList.aspx.cs" Inherits="WebApplication2.RepairList" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script>
        $(document).ready(function(){
            $('[data-toggle="tooltip"]').tooltip();   
        });
    </script>
    <style>
        .cssPager td {
            padding-left: 4px;
            padding-right: 4px;
        }
    </style>
    <div class="container-fluid">
        <div class="row">
            <div class="col-xs-12 text-center">
                <asp:GridView ID="repairListGrid" runat="server" GridLines="None" CssClass="table table-striped table-hover" AllowPaging="true" PageSize="50" OnPageIndexChanging="repairListGrid_PageIndexChanging" PagerSettings-Position="TopAndBottom" PagerStyle-HorizontalAlign="Center" PagerSettings-Mode="Numeric" PagerStyle-CssClass="cssPager"></asp:GridView>
            </div>
        </div>
    </div>

</asp:Content>