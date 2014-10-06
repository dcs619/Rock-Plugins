﻿<%@ Control Language="C#" AutoEventWireup="true" CodeFile="DefinedTypeList.ascx.cs" Inherits="RockWeb.Blocks.Core.DefinedTypeList" %>

<asp:UpdatePanel ID="upSettings" runat="server">
    <ContentTemplate>
        
        <div class="panel panel-block">
            <div class="panel-heading">
                <h1 class="panel-title"><i class="fa fa-book"></i> Defined Types List</h1>
            </div>
            <div class="panel-body">
                <div class="grid grid-panel">
                    <Rock:GridFilter ID="tFilter" runat="server">
                        <Rock:CategoryPicker ID="cpCategory" runat="server" Label="Category" Required="false" EntityTypeName="Rock.Model.DefinedType" />
                    </Rock:GridFilter>
                    <Rock:ModalAlert ID="mdGridWarning" runat="server" />
                    <Rock:Grid ID="gDefinedType" runat="server" AllowSorting="true" OnRowSelected="gDefinedType_Edit" TooltipField="Description">
                        <Columns>
                            <asp:BoundField DataField="Category" HeaderText="Category" SortExpression="Category.Name" />
                            <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
                            <asp:BoundField DataField="Description" HeaderText="Description" SortExpression="Description" />
                            <asp:BoundField DataField="FieldTypeName" HeaderText="Field Type" SortExpression="FieldTypeName" />
                            <Rock:DeleteField OnClick="gDefinedType_Delete" />
                        </Columns>
                    </Rock:Grid>
                </div>
            </div>
        </div>

    </ContentTemplate>
</asp:UpdatePanel>