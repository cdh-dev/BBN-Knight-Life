//
//  SettingsCourseDeleteCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/8/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib

class SettingsCourseDeleteCell: TableCell {
	
	init(clicked: @escaping () -> Void) {
		super.init("coursedelete", nib: "SettingsCourseDeleteCell")
		
		self.setHeight(44)
        
        self.setCallback {
            template, cell in
            
            guard let deleteCell = cell as? UISettingsCourseDeleteCell else {
                return
            }
            deleteCell.backgroundColor = Scheme.calenderAndBlocksBackground.color
        }
		
		self.setSelection() {
			_, _ in
			
			clicked()
		}
	}
	
}

class UISettingsCourseDeleteCell: UITableViewCell {
	
	
	
}
