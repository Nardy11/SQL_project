﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ClubRepresentativeReg.aspx.cs" Inherits="firstpro.ClubRepresentativeReg" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>ClubRepresentativeReg</title>
    <link rel="stylesheet" href="CSS.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Label ID="comment" runat="server" Text=" "></asp:Label>
        </div>
        <asp:TextBox ID="nameTB" runat="server" placeholder="Name" required = "True" MaxLength="20"></asp:TextBox>
        <br />
        <br />

        <asp:TextBox ID="usernameTB" runat="server" placeholder="User name" required = "True" MaxLength="20"></asp:TextBox>
        <br />
        <br />

        <asp:TextBox ID="clubnameTB" runat="server" placeholder="Club name" required = "True" MaxLength="20"></asp:TextBox>
        <br />
        <br />
        <asp:TextBox ID="passwordTB" runat="server" placeholder="Password" required = "True" type="password" MaxLength="20"></asp:TextBox>
        <br />
        <br />
        <asp:Button ID="RegisterB" runat="server" OnClick="Register" Text="Register" />
    </form>
</body>
</html>
