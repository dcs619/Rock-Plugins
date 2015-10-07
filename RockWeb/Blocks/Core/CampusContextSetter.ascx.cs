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
using System.ComponentModel;
using System.Linq;
using System.Runtime.Caching;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Rock;
using Rock.Attribute;
using Rock.Data;
using Rock.Model;
using Rock.Web.Cache;
using Rock.Web.UI;

namespace RockWeb.Blocks.Core
{
    /// <summary>
    /// Block that can be used to set the default campus context for the site
    /// </summary>
    [DisplayName( "Campus Context Setter" )]
    [Category( "Core" )]
    [Description( "Block that can be used to set the default campus context for the site." )]
    [CustomRadioListField( "Context Scope", "The scope of context to set", "Site,Page", true, "Site", order: 0 )]
    [TextField( "Current Item Template", "Lava template for the current item. The only merge field is {{ CampusName }}.", true, "{{ CampusName }}", order: 1 )]
    [TextField( "Dropdown Item Template", "Lava template for items in the dropdown. The only merge field is {{ CampusName }}.", true, "{{ CampusName }}", order: 2 )]
    [TextField( "No Campus Text", "The text displayed when no campus context is selected.", true, "All Campuses", order: 3 )]
    public partial class CampusContextSetter : RockBlock
    {
        #region Base Control Methods

        /// <summary>
        /// Raises the <see cref="E:System.Web.UI.Control.Init" /> event.
        /// </summary>
        /// <param name="e">An <see cref="T:System.EventArgs" /> object that contains the event data.</param>
        protected override void OnInit( EventArgs e )
        {
            base.OnInit( e );

            if ( Request.QueryString["campusId"] != null )
            {
                SetCampusContext();
            }
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

        /// <summary>
        /// Loads the drop downs.
        /// </summary>
        private void LoadDropDowns()
        {
            Dictionary<string, object> mergeObjects = new Dictionary<string, object>();

            var campusEntityType = EntityTypeCache.Read( "Rock.Model.Campus" );
            var defaultCampus = RockPage.GetCurrentContext( campusEntityType ) as Campus;

            if ( defaultCampus != null )
            {
                mergeObjects.Add( "CampusName", defaultCampus.Name );
                lCurrentSelection.Text = GetAttributeValue( "CurrentItemTemplate" ).ResolveMergeFields( mergeObjects );
            }
            else
            {
                lCurrentSelection.Text = GetAttributeValue( "NoCampusText" );
            }

            var campusList = CampusCache.All()
                .Select( a => new CampusItem { Name = a.Name, Id = a.Id } )
                .ToList();

            campusList.Add( new CampusItem
            {
                Name = GetAttributeValue( "NoCampusText" ),
                Id = Rock.Constants.All.ListItem.Value.AsInteger()
            } );

            var formattedCampuses = new Dictionary<int, string>();
            // run lava on each campus
            foreach ( var campus in campusList )
            {
                mergeObjects.Clear();
                mergeObjects.Add( "CampusName", campus.Name );
                campus.Name = GetAttributeValue( "DropdownItemTemplate" ).ResolveMergeFields( mergeObjects );
            }

            rptCampuses.DataSource = campusList;
            rptCampuses.DataBind();
        }

        #endregion

        #region Events

        /// <summary>
        /// Handles the ItemCommand event of the rptCampuses control.
        /// </summary>
        /// <param name="source">The source of the event.</param>
        /// <param name="e">The <see cref="RepeaterCommandEventArgs"/> instance containing the event data.</param>
        protected void rptCampuses_ItemCommand( object source, RepeaterCommandEventArgs e )
        {
            var campusId = e.CommandArgument.ToString();

            Request.QueryString.Set( "campus", campusId );

            bool pageScope = GetAttributeValue( "ContextScope" ) == "Page";
            var campus = new CampusService( new RockContext() ).Get( campusId.AsInteger() );
            if ( campus != null )
            {
                RockPage.SetContextCookie( campus, pageScope, true );
            }

            //Response.Redirect( string.Format( "{0}?{1}", Request.Url.AbsolutePath, Request.QueryString ) );
        }

        #endregion

        #region Methods

        /// <summary>
        /// Sets the context URL cookie.
        /// </summary>
        private void SetContextUrlCookie()
        {
            HttpCookie cookieUrl = new HttpCookie( "Rock.Campus.Context.Query" );
            cookieUrl["campusId"] = Request.QueryString["campusId"].ToString();
            cookieUrl.Expires = DateTime.Now.AddHours( 1 );
            Response.Cookies.Add( cookieUrl );
        }

        /// <summary>
        /// Clears the rock context.
        /// </summary>
        /// <param name="cookieName">Name of the cookie.</param>
        private void ClearRockContext( string cookieName )
        {
            var cookieKeys = Request.Cookies[cookieName].Value.Split( '&' ).ToArray();

            HttpCookie newRockCookie = new HttpCookie( cookieName );

            foreach ( var cookieKey in cookieKeys )
            {
                if ( !cookieKey.ToString().StartsWith( "Rock.Model.Campus" ) )
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

        /// <summary>
        /// Sets the campus context.
        /// </summary>
        private void SetCampusContext()
        {
            var campusContextQuery = Request.QueryString["campusId"];

            HttpCookie cookieUrl = Request.Cookies["Rock.Campus.Context.Query"];

            if ( campusContextQuery != null )
            {
                bool pageScope = GetAttributeValue( "ContextScope" ) == "Page";
                var campus = new CampusService( new RockContext() ).Get( campusContextQuery.ToString().AsInteger() );
                if ( campus != null )
                {
                    if ( cookieUrl == null || Request.QueryString["campusId"].ToString() != cookieUrl.Value.Replace( "campusId=", "" ) )
                    {
                        SetContextUrlCookie();
                        RockPage.SetContextCookie( campus, pageScope, true );
                    }
                }
                else
                {
                    if ( cookieUrl == null || Request.QueryString["campusId"].ToString() != cookieUrl.Value.Replace( "campusId=", "" ) )
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

        #endregion

        /// <summary>
        /// Campus Item
        /// </summary>
        public class CampusItem
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