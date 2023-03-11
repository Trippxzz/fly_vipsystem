CREATE TABLE IF NOT EXISTS `fly_vip` (                  
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` longtext NOT NULL,                 
  `identifier` varchar(100) DEFAULT 'notredeem',   
  `vip` varchar(100) NOT NULL,  
  `car` int(11) DEFAULT '0',    
  `ped` varchar(100) DEFAULT 'notavailable',   
  `money` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)                                    
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=LATIN1;