stock getLog(log) {
	new result[64];
	switch(log) {
		case CREATE_LOCATION: {
			format(result, sizeof(result),"Criou local publico");
			return result;
		}
		default: {
			format(result, sizeof(result),"| Ação não identificada |");
			return result;	
		}
	}
}

stock na() {
	new result[16];
	format(result, sizeof(result),"N/A");
	return result;
}

stock createLog(playerid, action, info[], codeB[], nameB[]) {
	/*	-->	codeB = codeBeneficiary -> código de quem recebeu o benefício | 
	  	-->	name  = nameBeneficiary  -> nome de quem recebeu o benefício  */
	new date[16], time[16];
	new hour = 0, minute = 0, second = 0, year = 0, month = 0, day = 0;
	getdate(year, month, day);
	gettime(hour, minute, second);
	format(date, sizeof(date),"%02d/%02d/%02d", day, month, year);
	format(time, sizeof(time), "%02d:%02d:%02d", hour, minute, second);
	new str[512];
	format(str, sizeof(str),"Nome: %s\nCode: %s\nAção: %s\nInfo: %s\nData: %s\nHorário %s\n",
	getNamePlayer(playerid), PlayerInfo[playerid][pCode], getLog(action), info, date, time);
	ShowPlayerDialog(playerid, DIALOG_DEBUG, DIALOG_STYLE_MSGBOX, T_DEBUG, str, "Ok", "");

	new query[512];
	mysql_format(ConexaoSQL, query, sizeof(query),"INSERT INTO `logadmin` (`logAdmin`,`logPlayer`,`logCodPlayer`,`logAction`,\
	`logInfo`,`logCodeBeneficiary`,`logNameBeneficiary`,`logData`,`logTime`) VALUES ('%s','%s','%s','%s','%s','%s','%s','%s','%s')",
	getPlayerAdmin(playerid), getNamePlayer(playerid), PlayerInfo[playerid][pCode], getLog(action), info, codeB, nameB, date, time);
	mysql_tquery(ConexaoSQL, query);
	return 1;
}

stock createLogAlter(codePlayer[], admin[], name[], action[]) {
	new query[512];
	mysql_format(ConexaoSQL, query, sizeof(query),"INSERT INTO `alterlog` (`codePlayer`, `logAdmin`, `namePlayer`, `logData`, `logHora`, \
		`logAction`) VALUES ('%s', '%s', '%s', '%s', '%s', '%s')", codePlayer, admin, name, getDateServer(), getTimeServer(), action);
	mysql_tquery(ConexaoSQL, query);
	return 1;
}