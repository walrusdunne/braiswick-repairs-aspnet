﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PhotogReports.aspx.cs" Inherits="WebApplication2.PhotogReports" %>
<asp:Content ID="Content1" ContentPlaceHolderID="headextra" runat="server">
    <style>
        select > option {
            font-family: monospace;
        }

        .top10 {
            margin-top: 10px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row top10">
        <div class="col-xs-6">
            <div class="panel panel-default">
                <div class="panel-heading"></div>
                <div class="panel-body">
                    <div class="row">
                        <div class="col-xs-4">ID: </div>
                        <div class="col-xs-8">
                            <asp:TextBox ID="reportID" runat="server" CssClass="form-control" ReadOnly="true" Columns="4"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row top10">
                        <div class="col-xs-4">Date: </div>
                        <div class="col-xs-8">
                            <asp:TextBox ID="reportDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row top10">
                        <div class="col-xs-4">Photographer: </div>
                        <div class="col-xs-8">
                            <asp:DropDownList ID="reportPhotographerDD" runat="server" CssClass="form-control"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="row top10">
                        <div class="col-xs-4">Cost: </div>
                        <div class="col-xs-8">
                            <asp:TextBox ID="reportCost" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xs-6">
            <div class="panel panel-default">
                <div class="panel-heading"></div>
                <div class="panel-body">
                    <div class="row">
                        <div class="col-xs-4">Status: </div>
                        <div class="col-xs-8">
                            <asp:DropDownList ID="reportStatus" runat="server" CssClass="form-control">
                                <asp:ListItem Text="COMPLAINT" Value="COMPLAINT"></asp:ListItem>
                                <asp:ListItem Text="FEEDBACK" Value="FEEDBACK"></asp:ListItem>
                                <asp:ListItem Text="LOSS" Value="LOSS"></asp:ListItem>
                                <asp:ListItem Text="PENDING" Value="PENDING"></asp:ListItem>
                                <asp:ListItem Text="POST" Value="POST"></asp:ListItem>
                                <asp:ListItem Text="REBOOKED" Value="REBOOKED"></asp:ListItem>
                                <asp:ListItem Text="REPORT" Value="REPORT"></asp:ListItem>
                                <asp:ListItem Text="RETAKE" Value="RETAKE"></asp:ListItem>
                                <asp:ListItem Text="SITE VISIT" Value="SITE VISIT"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row top10">
                        <div class="col-xs-4">Job: </div>
                        <div class="col-xs-8">
                            <asp:TextBox ID="reportJob" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row top10">
                        <div class="col-xs-4">School: </div>
                        <div class="col-xs-8">
                            <asp:TextBox ID="reportSchool" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row top10">
                        <div class="col-xs-4">Type: </div>
                        <div class="col-xs-8">
                            <asp:TextBox ID="reportType" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row top10">
        <div class="col-xs-12">
            <div class="panel panel-default">
                <div class="panel-heading"></div>
                <div class="panel-body">
                    <div class="row">
                        <div class="col-xs-4">Notes: </div>
                    </div>
                    <div class="row">
                        <div class="col-xs-12">
                            <asp:TextBox ID="reportNotes" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="6"></asp:TextBox>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row top10">
        <div class="col-xs-12">
            <div class="panel panel-default">
                <div class="panel-body">
                    <asp:Button ID="reportSave" runat="server" CssClass="btn btn-primary" Text="Save" OnClick="reportSave_Click" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
