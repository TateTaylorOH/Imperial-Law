Scriptname LCO_SimpleController_C_Cyrodiil extends LCO_SimpleControllerBase

;/inherited properties
Keyword CurrentOwnership
Keyword DefaultOwnership
Keyword ChangeOwnership
int newOwner
int defaultOwner
GlobalVariable realTimeUpdateDelay
GlobalVariable gameTimeUpdateDelay
Location thisLocation
Message Property Claim Auto
Message property NoClaim Auto
Message property QuestLocked Auto
ObjectReference Property ClaimingEnableParent Auto
/;

Location property myCounty Auto
{The County this dungeon is in.}
Location[] property Counties Auto
{used to select the claim message and County banner based on the myCounty property}
Message[] Property ClaimMessages Auto
{overrides the Claim property with a County-specific message selected from this array.}
Form[] Property CountyBanners Auto
{base forms for the County banner near the controller.}
Form Property DefaultBanner Auto
{base form for the default banner near the controller.}

ObjectReference myDefaultBanner
ObjectReference myCountyBanner

function getLocalBanners()
	int i = Counties.find(myCounty)
	Claim = ClaimMessages[i]
	myDefaultBanner = Game.findClosestReferenceOfTypeFromRef(DefaultBanner, self, 400.0)
	myCountyBanner = Game.findClosestReferenceOfTypeFromRef(CountyBanners[i], self, 400.0)
endFunction

int function processChoice(int selectedChoice, int currentOwner)
	if(selectedChoice == 0)
		return LCO.Default()
	elseif(selectedChoice == 1)
		return LCO.LocalHold()
	endIf
	return currentOwner
endFunction

function hide()
	parent.hide()
	myDefaultBanner.disableNoWait()
	myCountyBanner.disableNoWait()
endFunction

function updateBanners(int i = -1)
	if(i == -1)
		i = thisLocation.getKeywordData(CurrentOwnership) as int
	endIf
	if(i == LCO.Default())
		myDefaultBanner.enableNoWait()
		myCountyBanner.disableNoWait()
	elseif(i == LCO.LocalHold())
		myDefaultBanner.disableNoWait()
		myCountyBanner.enableNoWait()
	endIf
endFunction