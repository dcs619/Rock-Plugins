//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by the Rock.CodeGeneration project
//     Changes to this file will be lost when the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------
// <copyright>
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
using System.Linq;

using Rock.Data;

namespace Rock.Model
{
    /// <summary>
    /// EntityType Service class
    /// </summary>
    public partial class EntityTypeService : Service<EntityType>
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="EntityTypeService"/> class
        /// </summary>
        public EntityTypeService()
            : base()
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="EntityTypeService"/> class
        /// </summary>
        /// <param name="repository">The repository.</param>
        public EntityTypeService(IRepository<EntityType> repository) : base(repository)
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="EntityTypeService"/> class
        /// </summary>
        /// <param name="context">The context.</param>
        public EntityTypeService(RockContext context) : base(context)
        {
        }

        /// <summary>
        /// Determines whether this instance can delete the specified item.
        /// </summary>
        /// <param name="item">The item.</param>
        /// <param name="errorMessage">The error message.</param>
        /// <returns>
        ///   <c>true</c> if this instance can delete the specified item; otherwise, <c>false</c>.
        /// </returns>
        public bool CanDelete( EntityType item, out string errorMessage )
        {
            errorMessage = string.Empty;
 
            if ( new Service<Attribute>().Queryable().Any( a => a.EntityTypeId == item.Id ) )
            {
                errorMessage = string.Format( "This {0} is assigned to a {1}.", EntityType.FriendlyTypeName, Attribute.FriendlyTypeName );
                return false;
            }  
 
            if ( new Service<Audit>().Queryable().Any( a => a.EntityTypeId == item.Id ) )
            {
                errorMessage = string.Format( "This {0} is assigned to a {1}.", EntityType.FriendlyTypeName, Audit.FriendlyTypeName );
                return false;
            }  
 
            if ( new Service<Auth>().Queryable().Any( a => a.EntityTypeId == item.Id ) )
            {
                errorMessage = string.Format( "This {0} is assigned to a {1}.", EntityType.FriendlyTypeName, Auth.FriendlyTypeName );
                return false;
            }  
 
            if ( new Service<BinaryFile>().Queryable().Any( a => a.StorageEntityTypeId == item.Id ) )
            {
                errorMessage = string.Format( "This {0} is assigned to a {1}.", EntityType.FriendlyTypeName, BinaryFile.FriendlyTypeName );
                return false;
            }  
 
            if ( new Service<BinaryFileType>().Queryable().Any( a => a.StorageEntityTypeId == item.Id ) )
            {
                errorMessage = string.Format( "This {0} is assigned to a {1}.", EntityType.FriendlyTypeName, BinaryFileType.FriendlyTypeName );
                return false;
            }  
 
            if ( new Service<Category>().Queryable().Any( a => a.EntityTypeId == item.Id ) )
            {
                errorMessage = string.Format( "This {0} is assigned to a {1}.", EntityType.FriendlyTypeName, Category.FriendlyTypeName );
                return false;
            }  
 
            if ( new Service<Communication>().Queryable().Any( a => a.ChannelEntityTypeId == item.Id ) )
            {
                errorMessage = string.Format( "This {0} is assigned to a {1}.", EntityType.FriendlyTypeName, Communication.FriendlyTypeName );
                return false;
            }  
            
            // ignoring DataView,EntityTypeId 
            
            // ignoring DataView,TransformEntityTypeId 
 
            if ( new Service<DataViewFilter>().Queryable().Any( a => a.EntityTypeId == item.Id ) )
            {
                errorMessage = string.Format( "This {0} is assigned to a {1}.", EntityType.FriendlyTypeName, DataViewFilter.FriendlyTypeName );
                return false;
            }  
 
            if ( new Service<FinancialPersonSavedAccount>().Queryable().Any( a => a.GatewayEntityTypeId == item.Id ) )
            {
                errorMessage = string.Format( "This {0} is assigned to a {1}.", EntityType.FriendlyTypeName, FinancialPersonSavedAccount.FriendlyTypeName );
                return false;
            }  
 
            if ( new Service<FinancialScheduledTransaction>().Queryable().Any( a => a.GatewayEntityTypeId == item.Id ) )
            {
                errorMessage = string.Format( "This {0} is assigned to a {1}.", EntityType.FriendlyTypeName, FinancialScheduledTransaction.FriendlyTypeName );
                return false;
            }  
 
            if ( new Service<FinancialScheduledTransactionDetail>().Queryable().Any( a => a.EntityTypeId == item.Id ) )
            {
                errorMessage = string.Format( "This {0} is assigned to a {1}.", EntityType.FriendlyTypeName, FinancialScheduledTransactionDetail.FriendlyTypeName );
                return false;
            }  
 
            if ( new Service<FinancialTransaction>().Queryable().Any( a => a.GatewayEntityTypeId == item.Id ) )
            {
                errorMessage = string.Format( "This {0} is assigned to a {1}.", EntityType.FriendlyTypeName, FinancialTransaction.FriendlyTypeName );
                return false;
            }  
 
            if ( new Service<FinancialTransactionDetail>().Queryable().Any( a => a.EntityTypeId == item.Id ) )
            {
                errorMessage = string.Format( "This {0} is assigned to a {1}.", EntityType.FriendlyTypeName, FinancialTransactionDetail.FriendlyTypeName );
                return false;
            }  
            
            // ignoring History,EntityTypeId 
            
            // ignoring History,RelatedEntityTypeId 
 
            if ( new Service<NoteType>().Queryable().Any( a => a.EntityTypeId == item.Id ) )
            {
                errorMessage = string.Format( "This {0} is assigned to a {1}.", EntityType.FriendlyTypeName, NoteType.FriendlyTypeName );
                return false;
            }  
 
            if ( new Service<PersonBadge>().Queryable().Any( a => a.EntityTypeId == item.Id ) )
            {
                errorMessage = string.Format( "This {0} is assigned to a {1}.", EntityType.FriendlyTypeName, PersonBadge.FriendlyTypeName );
                return false;
            }  
 
            if ( new Service<Report>().Queryable().Any( a => a.EntityTypeId == item.Id ) )
            {
                errorMessage = string.Format( "This {0} is assigned to a {1}.", EntityType.FriendlyTypeName, Report.FriendlyTypeName );
                return false;
            }  
 
            if ( new Service<ReportField>().Queryable().Any( a => a.DataSelectComponentEntityTypeId == item.Id ) )
            {
                errorMessage = string.Format( "This {0} is assigned to a {1}.", EntityType.FriendlyTypeName, ReportField.FriendlyTypeName );
                return false;
            }  
 
            if ( new Service<Tag>().Queryable().Any( a => a.EntityTypeId == item.Id ) )
            {
                errorMessage = string.Format( "This {0} is assigned to a {1}.", EntityType.FriendlyTypeName, Tag.FriendlyTypeName );
                return false;
            }  
 
            if ( new Service<UserLogin>().Queryable().Any( a => a.EntityTypeId == item.Id ) )
            {
                errorMessage = string.Format( "This {0} is assigned to a {1}.", EntityType.FriendlyTypeName, UserLogin.FriendlyTypeName );
                return false;
            }  
 
            if ( new Service<WorkflowTrigger>().Queryable().Any( a => a.EntityTypeId == item.Id ) )
            {
                errorMessage = string.Format( "This {0} is assigned to a {1}.", EntityType.FriendlyTypeName, WorkflowTrigger.FriendlyTypeName );
                return false;
            }  
            return true;
        }
    }

    /// <summary>
    /// Generated Extension Methods
    /// </summary>
    public static partial class EntityTypeExtensionMethods
    {
        /// <summary>
        /// Clones this EntityType object to a new EntityType object
        /// </summary>
        /// <param name="source">The source.</param>
        /// <param name="deepCopy">if set to <c>true</c> a deep copy is made. If false, only the basic entity properties are copied.</param>
        /// <returns></returns>
        public static EntityType Clone( this EntityType source, bool deepCopy )
        {
            if (deepCopy)
            {
                return source.Clone() as EntityType;
            }
            else
            {
                var target = new EntityType();
                target.CopyPropertiesFrom( source );
                return target;
            }
        }

        /// <summary>
        /// Copies the properties from another EntityType object to this EntityType object
        /// </summary>
        /// <param name="target">The target.</param>
        /// <param name="source">The source.</param>
        public static void CopyPropertiesFrom( this EntityType target, EntityType source )
        {
            target.Name = source.Name;
            target.AssemblyName = source.AssemblyName;
            target.FriendlyName = source.FriendlyName;
            target.IsEntity = source.IsEntity;
            target.IsSecured = source.IsSecured;
            target.IsCommon = source.IsCommon;
            target.Id = source.Id;
            target.Guid = source.Guid;

        }
    }
}
