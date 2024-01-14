#ifndef FLUTTER_regradocorte_appLICATION_H_
#define FLUTTER_regradocorte_appLICATION_H_

#include <gtk/gtk.h>

G_DECLARE_FINAL_TYPE(MyApplication, regradocorte_application, MY, APPLICATION,
                     GtkApplication)

/**
 * regradocorte_application_new:
 *
 * Creates a new Flutter-based application.
 *
 * Returns: a new #MyApplication.
 */
MyApplication* regradocorte_application_new();

#endif  // FLUTTER_regradocorte_appLICATION_H_
