local gpgs = require( "plugin.gpgs" )
local json = require("json")

gpgs.enableDebug()

--scalers
local scale0X= ((display.actualContentWidth- display.contentWidth)*.5)
local scale0Y= ((display.actualContentHeight- display.contentHeight)*.5)

local myPlayerId = ""
local myGPGSName = ""
local otherPlayerId = ""
local roomId
local GPGSLogined = false
local myPlayerNum =0
math.randomseed(os.time()) 
myPlayerNum = math.random(214748364)
print( myPlayerNum )
local otherPlayerNum = 0
local triggerMultiplayer
local quitMultiplayer
local sendMyData
local playerLetterText
local updateBoard
local sceneGroup = display.newGroup( )
local currentBoard = {}
local gameTable= {}
gameTable.id= 0
gameTable.board = {}
--left to right and top to bottem
gameTable.board[1] = ""
gameTable.board[2] = ""
gameTable.board[3] = ""
gameTable.board[4] = ""
gameTable.board[4] = ""
gameTable.board[5] = ""
gameTable.board[6] = ""
gameTable.board[7] = ""
gameTable.board[8] = ""
gameTable.board[9] = ""
gameTable.winner = ""
local canPlay = false
local myType = "O" -- set to player two default
--
local handleGPGS
function handleGPGS( event )
	if (event.name == "init" and event.isError== false) then
		GPGSLogined = true
		gpgs.players.load({
	        listener = function(e)
	            if not e.isError then
	                myPlayerId = e.players[1].id
	            else
	            	print("could not get player id")
	            end
	        end
	    })
		gpgs.getAccountName( function ( e )
			if (e.isError) then
				print("could not get account name")
			else
				myGPGSName = e.accountName
			end
		end )
		triggerMultiplayer()
	elseif event.name == "init" and event.isError== false then
		gpgs.login( {userInitiated = true, listener=handleGPGS} )
	elseif event.name == "login" and event.isError== false and event.phase == "logged in" then
		GPGSLogined = true
		gpgs.players.load({
	        listener = function(e)
	            if not e.isError then
	                myPlayerId = e.players[1].id
	            else
	            	print("could not get player id")
	            end
	        end
	    })
		gpgs.getAccountName( function ( e )
			if (e.isError) then
				print("could not get account name")
			else
				myGPGSName = e.accountName
			end
		end )
		triggerMultiplayer()
	elseif event.name == "login" and event.isError == true and event.phase == "logged in" then
		gpgs.login( {userInitiated = true, listener=handleGPGS} )
	end
	return true
end
--display the game
sceneGroup.alpha = 1 -- start hidden
local background= display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight )
local line1 = display.newLine(sceneGroup,  scale0X*-1, 0, display.contentWidth, 0 )
line1.x, line1.y = display.contentCenterX-(display.actualContentWidth *.5), display.contentCenterY-100
line1:setStrokeColor( .5 )
line1.strokeWidth = 8
local line2 = display.newLine(sceneGroup,  scale0X*-1, 0, display.contentWidth, 0 )
line2.x, line2.y = display.contentCenterX-(display.actualContentWidth *.5), display.contentCenterY+100
line2:setStrokeColor( .5 )
line2.strokeWidth = 8
local line3 = display.newLine(sceneGroup,  0, scale0Y*-1, 0, display.contentHeight )
line3.x, line3.y = display.contentCenterX-58, display.contentCenterY-(display.contentHeight *.5)
line3:setStrokeColor( .5 )
line3.strokeWidth = 8
local line4 = display.newLine(sceneGroup,  0, scale0Y*-1, 0, display.contentHeight )
line4.x, line4.y = display.contentCenterX+58, display.contentCenterY-(display.contentHeight *.5)
line4:setStrokeColor( .5 )
line4.strokeWidth = 8
local tiles = {}
local myIndex = 1

local function tilesTouch( event )
	if (event.phase =="began") then
		local tile = event.target
		if (canPlay == true and tile.currentType == nil and gameTable.board[tile.index] == "") then
			gameTable.board[tile.index]= myType
			tile.currentType = myType
			sendMyData()
			updateBoard()
			canPlay = false
		end
	end
end
tiles[myIndex] = display.newRect( sceneGroup, 50, 68, 100, 136 )
tiles[myIndex]:setFillColor( 1,0,0,.5 )
tiles[myIndex].index = myIndex
tiles[myIndex]:addEventListener( "touch", tilesTouch )
myIndex = myIndex+1
tiles[myIndex] = display.newRect( sceneGroup, 160, 68, 110, 136 )
tiles[myIndex]:setFillColor( 1,0,0,.5 )
tiles[myIndex].index = myIndex
tiles[myIndex]:addEventListener( "touch", tilesTouch )
myIndex = myIndex+1
tiles[myIndex] = display.newRect( sceneGroup, 270, 68, 100, 136 )
tiles[myIndex]:setFillColor( 1,0,0,.5 )
tiles[myIndex].index = myIndex
tiles[myIndex]:addEventListener( "touch", tilesTouch )
myIndex = myIndex+1
tiles[myIndex] = display.newRect( sceneGroup, 50, 240, 100, 200 )
tiles[myIndex]:setFillColor( 1,0,0,.5 )
tiles[myIndex].index = myIndex
tiles[myIndex]:addEventListener( "touch", tilesTouch )
myIndex = myIndex+1
tiles[myIndex] = display.newRect( sceneGroup, 160, 240, 110, 200 )
tiles[myIndex]:setFillColor( 1,0,0,.5 )
tiles[myIndex].index = myIndex
tiles[myIndex]:addEventListener( "touch", tilesTouch )
myIndex = myIndex+1
tiles[myIndex] = display.newRect( sceneGroup, 270, 240, 100, 200 )
tiles[myIndex]:setFillColor( 1,0,0,.5 )
tiles[myIndex].index = myIndex
tiles[myIndex]:addEventListener( "touch", tilesTouch )
myIndex = myIndex+1
tiles[myIndex] = display.newRect( sceneGroup, 50, 435, 100, 183 )
tiles[myIndex]:setFillColor( 1,0,0,.5 )
tiles[myIndex].index = myIndex
tiles[myIndex]:addEventListener( "touch", tilesTouch )
myIndex = myIndex+1
tiles[myIndex] = display.newRect( sceneGroup, 160, 435, 110, 183 )
tiles[myIndex]:setFillColor( 1,0,0,.5 )
tiles[myIndex].index = myIndex
tiles[myIndex]:addEventListener( "touch", tilesTouch )
myIndex = myIndex+1
tiles[myIndex] = display.newRect( sceneGroup, 270, 435, 100, 183 )
tiles[myIndex]:setFillColor( 1,0,0,.5 )
tiles[myIndex].index = myIndex
tiles[myIndex]:addEventListener( "touch", tilesTouch )
myIndex = myIndex+1
--refresh board
function updateBoard(  )
	for i=1,9 do
		if (gameTable.board[i]~= "" and currentBoard[i] == nil) then
			currentBoard[i] = display.newText( sceneGroup, gameTable.board[i], tiles[i].x, tiles[i].y, native.systemFont, 100 )
		end
	end
	
	local isWinner = false
	local function checkWinner( )
		if (gameTable.board[1] == myType and gameTable.board[2] == myType and gameTable.board[3] == myType) then -- row 1
			return true
		elseif (gameTable.board[4] == myType and gameTable.board[5] == myType and gameTable.board[6] == myType) then -- row 2
			return true
		elseif (gameTable.board[7] == myType and gameTable.board[8] == myType and gameTable.board[9] == myType) then -- row 3
			return true
		elseif (gameTable.board[1] == myType and gameTable.board[4] == myType and gameTable.board[7] == myType) then -- col 1
			return true
		elseif (gameTable.board[2] == myType and gameTable.board[5] == myType and gameTable.board[8] == myType) then -- col 2
			return true
		elseif (gameTable.board[3] == myType and gameTable.board[6] == myType and gameTable.board[9] == myType) then -- col 3
			return true
		elseif (gameTable.board[1] == myType and gameTable.board[5] == myType and gameTable.board[9] == myType) then -- dig 1
			return true
		elseif (gameTable.board[3] == myType and gameTable.board[5] == myType and gameTable.board[7] == myType) then -- dig 2
			return true
		else
			return false
		end
	end
	isWinner=checkWinner()
	print( isWinner )
	if (isWinner == true) then
		canPlay = false
		gameTable.winner = myType
		sendMyData()
		playerLetterText.text = "you win, reset app to play again"
	end
end
--multiplayer started
function triggerMultiplayer( )
	sceneGroup.alpha = 1
	local function handleRealtime( event )
	    if (event.phase == "created") then

	    	gpgs.multiplayer.realtime.show({roomId= event.roomId, minPlayersRequired = 1, listener = function ( e )
	    		print("-------------")
	    		print(json.encode(e))
	    		print("-------------")
	    		if (e.isError == false) then
	    			print("user quit show")
	    		else

	    		end
	    	end})
	    end
        if event.phase == "connected" then
        	roomId = event.roomId
        	gpgs.multiplayer.realtime.sendReliably({roomId = roomId, payload= tostring(myPlayerNum)})
        end
	end
	local function dataHandle( event )
		if( event.payload ) then
	    	if (tonumber(event.payload )) then -- handle
	    		if (event.fromPlayerID ~= myPlayerId) then -- not my data
	        		otherPlayerNum = tonumber(event.payload)
	        	end
	        	if (otherPlayerNum < myPlayerNum) then
	        		myType = "X"
	    			canPlay= true
	        	end
	        	display.remove( playerLetterText )
	        	playerLetterText = display.newText( sceneGroup, myType, display.contentCenterX, 20, native.systemFontBold, 15 )
	        else -- is table data
	        	if (event.fromPlayerID ~= myPlayerId) then -- not my data
	        		gameTable = json.decode( event.payload)
	        		updateBoard()
	        		canPlay= true
	        		if (gameTable.winner and gameTable.winner ~= "") then
	        			canPlay = false
	        			playerLetterText.text = "you lose, reset app to play again"
	        		end
	        	else -- my data
	        		gameTable = json.decode( event.payload )
	        		updateBoard()
	        	end
	    	end
        end
	end
	gpgs.multiplayer.realtime.setListeners({message=dataHandle, room = handleRealtime})
	gpgs.multiplayer.realtime.create({automatch = {minPlayers = 1, maxPlayers = 1}})
end
function sendMyData( )
	gpgs.multiplayer.realtime.sendReliably({roomId = roomId, payload= json.encode( gameTable )})
end
--start game
timer.performWithDelay( 300, function (  )
	local startInt
	function startInt( e)
		if (e.phase== "logged in") then
			gpgs.init(handleGPGS)
		else
			gpgs.login( {userInitiated = true, listener = startInt} )
		end
	end
	gpgs.login( {userInitiated = true, listener = startInt} )
end )
