# background:
# setup:  https://docs.xebialabs.com/xl-release/how-to/create-a-jdbc-export-hook.html
# sample:  https://github.com/xebialabs/xl-release-samples/tree/master/mysql-jdbc-export-hook
# writing jython:  https://docs.xebialabs.com/xl-deploy/how-to/writing-jython-scripts-for-xl-deploy.html
# export hook:  https://docs.xebialabs.com/xl-release/how-to/create-an-export-hook.html
# Release object:  https://docs.xebialabs.com/jython-docs/#!/xl-release/4.7.x/service/com.xebialabs.xlrelease.domain.Release
# REST API documentation:  https://docs.xebialabs.com/xl-release/4.7.x/rest-api/
import time
import datetime
from datetime import datetime

# translate python NONE to empty string
def xstr(s):
    if s is None:
        return ''
    return str(s)

# decode booleans to MySQL TINYINT
def xbool(s):
    if s is None:
        return 0
    elif s is True:
        return 1
    return 0

# ensure that null values are set to 0 where appropriate
def default_zero(element):
  if element is None:
    return 0
  else:
    return element

# modify XL Release date string to a MySQL DATETIME
def modify_datestr(element):
  if element is None:
    return 'NULL'   #strip off ticks when doing actual insert
  else:
    #sample = "Thu Aug 27 15:23:28 EDT 2015"
    #           %a  %b %d %H:%MM:%SS %Z %Y
    #return time.mktime(datetime.datetime.strptime(element, "%a %b %d %H:%MM:%SS %Z %Y").timetuple())
    date_object = datetime.strptime(element, '%a %b %d %H:%MM:%SS %Z %Y')
    return time.strptime(element, '%a %b %d %H:%MM:%SS %Z %Y')

connection = exportHook.getJdbcConnection()

try:
  statement = connection.createStatement()

  releaseId = xstr(release.id)
  title = xstr(release.title)
  description = xstr(release.description)
  plannedDuration = default_zero(release.plannedDuration)
  flagComment = xstr(release.flagComment)
  abortOnFailure = xbool(release.abortOnFailure)
  allowConcurrentReleasesFromTrigger = xbool(release.allowConcurrentReleasesFromTrigger)
  createdFromTrigger = xbool(release.createdFromTrigger)
  scriptUsername = xstr(release.scriptUsername)
  scriptUserPassword = xstr(release.scriptUserPassword)

  # TODO:  figure out what this is when not set - probably ''?
  # ref:  http://stackoverflow.com/questions/5507948/how-can-i-insert-null-data-into-mysql-database-with-python
  #
  #scheduledStartDate = modify_datestr(release.scheduledStartDate)
  #if release.scheduledStartDate is None:
  #  scheduledStartDate = "NULL"
  scheduledStartDate = "NULL"

  #TODO:  figure out what this is when not set - probably ''?
  #dueDate = modify_datestr(release.dueDate)
  #if release.dueDate is None:
  #  dueDate = "NULL"
  dueDate = "NULL"

  #TODO:  convert the date to DATETIME
  #startDate = modify_datestr(release.startDate)
  startDate = '2015-08-27 15:00:00'
  #endDate = modify_datestr(release.endDate)
  endDate = '2015-08-27 15:10:00'
  
  # TODO: need method to look up owner ID based on STRING
  #sql = "SELECT ownerId FROM XLR_PERSON WHERE status = 'release.owner'" 
  #logger.debug("Executing SQL statement: %s" % sql)
  #flagId = statement.executeUpdate(sql)
  ownerId = 1

  # TODO: need method to look up flag ID based on STRING
  # 1=OK, 2=ATTENTION_NEEDED, 3=AT_RISK
  #sql = "SELECT flagId FROM XLR_FLAG WHERE status = 'release.flagStatus'" 
  #logger.debug("Executing SQL statement: %s" % sql)
  #flagId = statement.executeUpdate(sql)
  flagId = 1
  
  # TODO: walk through release.releaseTriggers , then look up each from XLR_TRIGGER
  # ref. releaseTriggers (array[ReleaseTrigger], optional): The triggers that may start a release from a template. (Templates only),
  triggerId = 2

  # TODO: need method to look up realFlagStatus ID based on STRING
  #sql = "SELECT flagId FROM XLR_FLAG WHERE status = 'release.realFlagStatus'" 
  #logger.debug("Executing SQL statement: %s" % sql)
  #realFlagStatusId = statement.executeUpdate(sql)
  realFlagStatusId = 1

  # TODO: need method to look up stateId based on STRING
  #sql = "SELECT stateId FROM XLR_STATE WHERE state = 'release.status'" 
  #logger.debug("Executing SQL statement: %s" % sql)
  #stateId = statement.executeUpdate(sql)
  stateId = 1

  # TODO: need method to look up stateId based on STRING
  #sql = "SELECT templateId FROM XLR_TEMPLATE WHERE state = 'release.originTemplateId'" 
  #logger.debug("Executing SQL statement: %s" % sql)
  #originTemplateId = statement.executeUpdate(sql)
  originTemplateId = 'Release6903453'

  #TODO:  Start/End transation!

  # ---------------------------------------
  # SAMPLE
  # 
  # INSERT INTO XLR_RELEASE (releaseId,title,description,ownerId, scheduledStartDate,dueDate,startDate,endDate,plannedDuration,
  # flagId,flagComment,triggerId,realFlagStatusId,stateId,abortOnFailure,allowConcurrentReleasesFromTrigger,originTemplateId,createdFromTrigger,
  # scriptUsername,scriptUserPassword) 
  # VALUES ('Applications/Release423992','Testing SQL','',1,NULL,NULL,'2015-08-27 15:00:00','2015-08-27 15:10:00',
  # 0,1,'',2,1,4,0,1,'Release6903453',0,'','')
  # ---------------------------------------

  # In production code you should use java.sql.PreparedStatement, actually.
  sql = "INSERT INTO XLR_RELEASE (releaseId,title,description,ownerId, scheduledStartDate,dueDate,startDate,endDate,plannedDuration,flagId,flagComment,triggerId,realFlagStatusId,stateId,abortOnFailure,allowConcurrentReleasesFromTrigger,originTemplateId,createdFromTrigger,scriptUsername,scriptUserPassword) VALUES ('%s','%s','%s',%s,%s,%s,'%s','%s',%s,%s,'%s',%s,%s,%s,%s,%s,'%s',%s,'%s','%s')" % (releaseId,title,description,ownerId,scheduledStartDate,dueDate,startDate,endDate,plannedDuration,flagId,flagComment,triggerId,realFlagStatusId,stateId,abortOnFailure,allowConcurrentReleasesFromTrigger,originTemplateId,createdFromTrigger,scriptUsername,scriptUserPassword)
  logger.info("Executing SQL statement: %s" % sql)
  statement.executeUpdate(sql)

  # TODO:  walk through release object, and populate  XLR_TEAM
  # ref. teams (array[Team], optional): The teams configured on the release.,

  #TODO:  walk through release object, and populate XLR_ATTACHMENTS
  # ref. attachments (array[Attachment], optional): File attachments of the release.

  #TODO:  walk through release object, and poplulate XLR_RELEASE_PHASE
  # Does this mean for each PHASE object, need to extract phase info, and insert into XLR_PHASE?
  #  ref. phases (array[Phase], optional): The list of phases in the release.,
 
  # TODO:  walk through release object, and populate XLR_RELEASE_STATUS_TAGS
  #  ref.  tags (array[string], optional): The tags of the release. Tags can be used for grouping and querying.,

  # TODO:  walk through release object, and populate XLR_RELEASE_VARIABLE
  #  ref.  variableValues (object, optional): The map of variables and their values. Variable keys are in ${...} format.,
  #        passwordVariableValues (object, optional): The map of password variables and their values. Variable keys are in ${...} format. Values are encrypted.,

finally:
  connection.close()