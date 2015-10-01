﻿// <copyright>
// Copyright 2013 by the Spark Development Network
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// </copyright>
//
using System;
using System.Collections.Generic;
using System.Runtime.Caching;
using System.ComponentModel;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Rock;
using Rock.Attribute;
using Rock.Data;
using Rock.Model;
using Rock.Web;
using Rock.Web.Cache;
using Rock.Web.UI;
using Rock.Web.UI.Controls;

namespace RockWeb.Blocks.Core
{
    /// <summary>
    /// Block that can be used to set the default group context for the site
    /// </summary>
    [DisplayName( "Group Context Setter" )]
    [Category( "Core" )]
    [Description( "Block that can be used to set the default group context for the site." )]

    [GroupTypeGroupField( "Group Filter", "Select group type and root group to filter groups by root group. Leave root group blank to filter by group type.", "Root Group" )]
    [CustomRadioListField( "Context Scope", "The scope of context to set", "Site,Page", true, "Site" )]
    [TextField( "No Group Text", "The text to show when there is no group in the context.", true, "All Groups", order: 3 )]
    public partial class GroupContextSetter : RockBlock
    {
        #region Base Control Methods

        protected override void OnInit( EventArgs e )
        {
            base.OnInit( e );

            if ( Request.QueryString["groupId"] != null )
            {
                SetGroupContext();
            }
        
            // this event gets fired after block settings are updated. it's nice to repaint the screen if these settings would alter it
            this.BlockUpdated += Block_BlockUpdated;
            this.AddConfigurationUpdateTrigger( upnlContent );
        }

        /// <summary>
        /// Raises the <see cref="E:System.Web.UI.Control.Load" /> event.
        /// </summary>
        /// <param name="e">The <see cref="T:System.EventArgs" /> object that contains the event data.</param>
        protected override void OnLoad( EventArgs e )
        {
            base.OnLoad( e );
            
            if ( !Page.IsPostBack )
            {
                LoadDropDowns();
            }
        }

        private void SetContextUrlCookie()
        {
            HttpCookie cookieUrl = new HttpCookie( "Rock.Group.Context.Query" );
            cookieUrl["groupId"] = Request.QueryString["groupId"].ToString();
            cookieUrl.Expires = DateTime.Now.AddHours( 1 );
            Response.Cookies.Add( cookieUrl );
        }

        private void ClearRockContext( string cookieName )
        {
            var cookieKeys = Request.Cookies[cookieName].Value.Split( '&' ).ToArray();

            HttpCookie newRockCookie = new HttpCookie( cookieName );

            foreach ( var cookieKey in cookieKeys )
            {

                if ( !cookieKey.ToString().StartsWith( "Rock.Model.Group" ) )
                {
                    var cookieValue = cookieKey.Split( '=' );

                    var cookieId = cookieValue[0].ToString();
                    var cookieHash = cookieValue[1].ToString();

                    newRockCookie[cookieId] = cookieHash;
                }
            }

            newRockCookie.Expires = DateTime.Now.AddHours( 1 );
            Response.Cookies.Add( newRockCookie );
        }

        private void SetGroupContext()
        {
            var groupContextQuery = Request.QueryString["groupId"];

            if ( groupContextQuery != null )
            {

                bool pageScope = GetAttributeValue( "ContextScope" ) == "Page";
                var group = new GroupService( new RockContext() ).Get( groupContextQuery.ToString().AsInteger() );

                HttpCookie cookieUrl = Request.Cookies["Rock.Group.Context.Query"];

                if ( group != null )
                {
                    if ( cookieUrl == null || Request.QueryString["groupId"].ToString() != cookieUrl.Value.Replace( "groupId=", "" ) )
                    {
                        SetContextUrlCookie();
                        RockPage.SetContextCookie( group, pageScope, true );
                    }
                }
                else
                {
                    if ( cookieUrl == null || Request.QueryString["groupId"].ToString() != cookieUrl.Value.Replace( "groupId=", "" ) )
                    {
                        SetContextUrlCookie();

                        // Check for a page specific Rock Context Cookie
                        if ( Request.Cookies["Rock_Context:" + RockPage.PageId.ToString()].HasKeys )
                        {
                            ClearRockContext( "Rock_Context:" + RockPage.PageId.ToString() );
                        }

                        // Check for a site specific Rock Context Cookie
                        if ( Request.Cookies["Rock_Context"].HasKeys )
                        {
                            ClearRockContext( "Rock_Context" );
                        }

                        // Refresh the page once we modify the cookies
                        Response.Redirect( Request.Url.ToString() );
                    }
                }
            }
        }

        /// <summary>
        /// Loads the groups.
        /// </summary>
        private void LoadDropDowns()
        {
            var parts = ( GetAttributeValue( "GroupFilter" ) ?? string.Empty ).Split( '|' );
            Guid? groupTypeGuid = null;
            Guid? rootGroupGuid = null;

           
            if ( parts.Length >= 1 )
            {
                groupTypeGuid = parts[0].AsGuidOrNull();
                if ( parts.Length >= 2 )
                {
                    rootGroupGuid = parts[1].AsGuidOrNull();
                }
            }

            var groupEntityType = EntityTypeCache.Read( "Rock.Model.Group" );
            
            var defaultGroup = RockPage.GetCurrentContext( groupEntityType ) as Group;
            var groupService = new GroupService( new RockContext() );
            IQueryable<Group> qryGroups = null;

            // if rootGroup is set, use that as the filter.  Otherwise, use GroupType as the filter
            if ( rootGroupGuid.HasValue )
            {
                var rootGroup = groupService.Get( rootGroupGuid.Value );
                if ( rootGroup != null )
                {
                    qryGroups = groupService.GetAllDescendents( rootGroup.Id ).AsQueryable();
                }
            }
            else if ( groupTypeGuid.HasValue )
            {
                qryGroups = groupService.Queryable().Where( a => a.GroupType.Guid == groupTypeGuid.Value );
            }

            if ( qryGroups == null )
            {
                nbSelectGroupTypeWarning.Visible = true;
                lCurrentSelection.Text = string.Empty;
                rptGroups.Visible = false;
            }
            else
            {
                nbSelectGroupTypeWarning.Visible = false;
                rptGroups.Visible = true;

                lCurrentSelection.Text = defaultGroup != null ? defaultGroup.ToString() : GetAttributeValue( "NoGroupText" );

                List<GroupItem> groups = new List<GroupItem>();
                groups.Add( new GroupItem { Name = GetAttributeValue( "NoGroupText" ), Id = Rock.Constants.All.ListItem.Value.AsInteger() } );
                
                var groupsList = qryGroups.OrderBy( a => a.Order ).ThenBy( a => a.Name ).ToList().Select( a => new { a.Name, a.Id } ).ToList();

                foreach ( var groupItem in groupsList )
                {
                    groups.Add( new GroupItem { Name = groupItem.Name, Id = groupItem.Id } );
                }

                rptGroups.DataSource = groups;
                rptGroups.DataBind();
            }
        }

        /// <summary>
        /// Handles the BlockUpdated event of the Block control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="EventArgs"/> instance containing the event data.</param>
        protected void Block_BlockUpdated( object sender, EventArgs e )
        {
            LoadDropDowns();
        }

        #endregion

        #region Methods

        /// <summary>
        /// Handles the ItemCommand event of the rptGroups control.
        /// </summary>
        /// <param name="source">The source of the event.</param>
        /// <param name="e">The <see cref="RepeaterCommandEventArgs"/> instance containing the event data.</param>
        protected void rptGroups_ItemCommand( object source, RepeaterCommandEventArgs e )
        {
            bool pageScope = GetAttributeValue( "ContextScope" ) == "Page";
            var group = new GroupService( new RockContext() ).Get( e.CommandArgument.ToString().AsInteger() );

            var nameValues = HttpUtility.ParseQueryString( Request.QueryString.ToString() );
            nameValues.Set( "groupId", e.CommandArgument.ToString() );
            string url = Request.Url.AbsolutePath;
            string updatedQueryString = "?" + nameValues.ToString();

            // Only update the Context Cookie if the Group is valid
            if ( group != null )
            {
                RockPage.SetContextCookie( group, pageScope, false );
            }

            Response.Redirect( url + updatedQueryString );
        }

        #endregion

        /// <summary>
        /// Schedule Item
        /// </summary>
        public class GroupItem
        {
            /// <summary>
            /// Gets or sets the name.
            /// </summary>
            /// <value>
            /// The name.
            /// </value>
            public string Name { get; set; }

            /// <summary>
            /// Gets or sets the identifier.
            /// </summary>
            /// <value>
            /// The identifier.
            /// </value>
            public int Id { get; set; }
        }
    }
}